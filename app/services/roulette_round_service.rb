class RouletteRoundService
  COLORS = %w[verde rojo negro].freeze
  COLOR_PROBABILITIES = [ 0.02, 0.49, 0.49 ] # verde, rojo, negro

  def self.perform
    Rails.logger.info "Jugando una ronda de ruleta"

    round = Round.create!(result: nil)
    players = Player.where("money > 0")

    bets = players.map do |player|
      Rails.logger.info "Jugador #{player.name} tiene #{player.money}"
      hot_week_ahead = WeatherService.hot_week_ahead?
      amount = if player.profile == "ia"
        ia_bet_amount(player, hot_week_ahead)
      else
        bet_amount(player.money)
      end
      color = pick_color
      Rails.logger.info "Jugador #{player.name} apuesta #{amount} a #{color}"
      Bet.create!(
        player: player,
        round: round,
        amount: amount,
        color: color
      )
    end

    result = pick_color
    round.update!(result: result)

    bets.each do |bet|
      payout = payout_for_bet(bet, result)
      player = bet.player
      player.update!(money: player.money - bet.amount + payout)
      bet.update!(winnings: payout)
    end

    round
  end

  def self.bet_amount(money)
    return money if money <= 1000

    hot_week_ahead = WeatherService.hot_week_ahead?

    if hot_week_ahead
      percent = rand(3..7) / 100.0
    else
      percent = rand(8..15) / 100.0
    end

    (money * percent).to_i
  end

  def self.pick_color
    r = rand
    case r
    when 0...0.02 then "verde"
    when 0.02...0.51 then "rojo"
    else "negro"
    end
  end

  def self.payout_for_bet(bet, result)
    return 0 unless bet.color == result
    if result == "verde"
      bet.amount * 15
    else
      bet.amount * 2
    end
  end

  def self.ia_bet_amount(player, hot_week_ahead)
    OpenAiRequest.perform(player, hot_week_ahead)
  end
end
