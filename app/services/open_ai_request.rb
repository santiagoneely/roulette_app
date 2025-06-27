module OpenAiRequest
  require 'openai'

  def self.perform(player, hot_week_ahead)
    Rails.logger.info "Jugador #{player.name} tiene #{player.money} y perfil #{player.profile}, clima #{hot_week_ahead}"
    client = OpenAI::Client.new(access_token: ENV['OPENAI_API_KEY'])
    rango = hot_week_ahead ? "3% y 7%" : "8% y 15%"
    history = history_bets(player)
    puts "History: #{history}"
    Rails.logger.info "History: #{history}"
    prompt = "Eres un jugador de ruleta con $#{player.money}.  ¿Qué porcentaje de tu dinero apostarías entre #{rango}? Solo responde el número, sin el símbolo de porcentaje ni texto extra. Es importante que solamente respondas un porcentaje del dinero, no el monto total. Las ultimas apuestas fueron: #{history}"
    response = client.chat(
      parameters: {
      model: "gpt-3.5-turbo",
        messages: [{ role: "user", content: prompt }]
      }
    )
    percent_str = response.dig("choices", 0, "message", "content").to_s.strip
    percent = percent_str.to_f / 100.0
    # Si la respuesta no es válida, usa un valor aleatorio del rango
    if percent <= 0
      percent = hot_week_ahead ? rand(3..7) / 100.0 : rand(8..15) / 100.0
    end
    (player.money * percent).to_i
  end

  private

  def self.history_bets(player)
    last_bets = player.bets.order(created_at: :desc).limit(3)
    history = last_bets.map do |bet|
      "Apostó $#{bet.amount} a #{bet.color.capitalize} y #{bet.color == bet.round.result ? 'ganó' : 'perdió'}"
    end.join('. ')
    history
  end
end
