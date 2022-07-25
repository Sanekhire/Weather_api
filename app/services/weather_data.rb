# frozen_string_literal: true

class WeatherData
  attr_reader :city_loc

  def initialize(apikey)
    @apikey = apikey
  end

  def get_forecast(city)
    @city_loc = Location.find_by(city_name: city)
    basic_url = 'http://dataservice.accuweather.com/currentconditions/v1/'
    full_url = "#{basic_url}#{@city_loc.location_key}/historical/24?apikey=#{@apikey}"
    JSON.parse(HTTP.get(full_url))
  end

  def self.load_data(city)
    access = new(Rails.application.credentials.weather_api_key)
    access.get_forecast(city).each do |data|
      Forecast.where(date: (data['EpochTime'])).first_or_create(temp: data.dig('Temperature', 'Metric', 'Value'),
                                                                location_id: access.city_loc.id)
    end
  end
end
