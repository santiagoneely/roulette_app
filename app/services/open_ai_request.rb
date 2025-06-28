module OpenAiRequest
  require "openai"

  def self.perform(player, hot_week_ahead)
    Rails.logger.info log_player_info(player, hot_week_ahead)
    percent = fetch_percentage_from_ai(player, hot_week_ahead)
    percent = fallback_percent(percent, hot_week_ahead)
    calculate_bet_amount(player.money, percent)
  end

  private

  def self.log_player_info(player, hot_week_ahead)
    "Jugador #{player.name} tiene #{player.money} y perfil #{player.profile}, clima #{hot_week_ahead}"
  end

  def self.fetch_percentage_from_ai(player, hot_week_ahead)
    client = OpenAI::Client.new(access_token: ENV["OPENAI_API_KEY"])
    prompt = build_prompt(player, hot_week_ahead)
    response = client.chat(
      parameters: {
        model: "gpt-3.5-turbo",
        messages: [ { role: "user", content: prompt } ]
      }
    )
    percent_str = response.dig("choices", 0, "message", "content").to_s.strip
    percent_str.to_f / 100.0
  end

  def self.build_prompt(player, hot_week_ahead)
    rango = hot_week_ahead ? "3% y 7%" : "8% y 15%"
    history = history_bets(player)
    "Eres un jugador de ruleta con $#{player.money}.  ¿Qué porcentaje de tu dinero apostarías entre #{rango}? Solo responde el número, sin el símbolo de porcentaje ni texto extra. Es importante que solamente respondas un porcentaje del dinero, no el monto total. Las ultimas apuestas fueron: #{history}"
  end

  def self.fallback_percent(percent, hot_week_ahead)
    if percent <= 0
      hot_week_ahead ? rand(3..7) / 100.0 : rand(8..15) / 100.0
    else
      percent
    end
  end

  def self.calculate_bet_amount(money, percent)
    (money * percent).to_i
  end

  def self.history_bets(player)
    last_bets = player.bets.order(created_at: :desc).limit(3)
    last_bets.map do |bet|
      "Apostó $#{bet.amount} a #{bet.color.capitalize} y #{bet.color == bet.round.result ? 'ganó' : 'perdió'}"
    end.join(". ")
  end
end
