# frozen_string_literal: true

class Weather
  attr_reader :city_loc

  def initialize(apikey)
    @apikey = apikey
  end

  def get_forecast(city)
    basic_url = 'http://dataservice.accuweather.com/currentconditions/v1/'
    full_url = "#{basic_url}#{city.location_key}/historical/24?apikey=#{@apikey}"
    JSON.parse(HTTP.get(full_url))
  end

  def self.load_data
    access = new(Rails.application.credentials.weather_api_key)
    Location.all.each do |city|
      access.get_forecast(city).each do |data|
        city.forecasts.find_or_create_by(date: (data['EpochTime'])) do |f|
          f.temp = data.dig('Temperature', 'Metric', 'Value')
        end
      end
    end
  end
end
