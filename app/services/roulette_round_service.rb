class RouletteRoundService
  COLORS = %w[verde rojo negro].freeze
  COLOR_PROBABILITIES = [ 0.02, 0.49, 0.49 ] # verde, rojo, negro

  def self.perform(origin: "manual")
    Rails.logger.info "Jugando una ronda de ruleta"
    round = create_round(origin)
    players = active_players
    bets = create_bets_for_players(players, round)
    result = pick_color
    update_round_result(round, result)
    process_bets_payouts(bets, result)
    round
  end

  private

  def self.create_round(origin)
    Round.create!(result: nil, origin: origin)
  end

  def self.active_players
    Player.active
  end

  def self.create_bets_for_players(players, round)
    players.map do |player|
      Rails.logger.info "Jugador #{player.name} tiene #{player.money}"
      hot_week_ahead = WeatherService.hot_week_ahead?
      amount = player.profile == "ia" ? ia_bet_amount(player, hot_week_ahead) : bet_amount(player.money)
      color = pick_color
      Rails.logger.info "Jugador #{player.name} apuesta #{amount} a #{color}"
      Bet.create!(
        player: player,
        round: round,
        amount: amount,
        color: color
      )
    end
  end

  def self.update_round_result(round, result)
    round.update!(result: result)
  end

  def self.process_bets_payouts(bets, result)
    bets.each do |bet|
      payout = payout_for_bet(bet, result)
      player = bet.player
      player.update!(money: player.money - bet.amount + payout)
      bet.update!(winnings: payout)
    end
  end

  def self.bet_amount(money)
    return money if money <= 1000
    hot_week_ahead = WeatherService.hot_week_ahead?
    percent = hot_week_ahead ? rand(3..7) / 100.0 : rand(8..15) / 100.0
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
    result == "verde" ? bet.amount * 15 : bet.amount * 2
  end

  def self.ia_bet_amount(player, hot_week_ahead)
    OpenAiRequest.perform(player, hot_week_ahead)
  end
end
