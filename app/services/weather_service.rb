class WeatherService
  include HTTParty
  base_uri "http://api.weatherapi.com/v1"

  # Método que solo hace el request y retorna el forecast de 7 días para Santiago
  def self.forecast
    api_key = ENV["WEATHER_API_KEY"]
    city = "Santiago"

    response = get("/forecast.json", query: {
      key: api_key,
      q: city,
      days: 7,
      aqi: "no",
      alerts: "no"
    })
    response.success? ? response : nil
  end

  # Método que evalúa si hay algún día con más de 23°C en el forecast
  def self.hot_week_ahead?
    response = forecast
    return false unless response

    forecast_days = response.dig("forecast", "forecastday")
    return false unless forecast_days

    temps_by_day = forecast_days.map { |day| { date: day["date"], max_temp: day["day"]["maxtemp_c"] } }
    forecast_days.any? { |day| day["day"]["maxtemp_c"] > 23 }
  end
end
