# frozen_string_literal: true

class LoadLocationKey
  def initialize(apikey)
    @apikey = apikey
  end

  def load_location_key
    resourse_url = 'http://dataservice.accuweather.com/locations/v1/cities/search'
    cities = Location.where(location_key: nil)

    cities.each do |city|
      full_url = "#{resourse_url}?apikey=#{@apikey}&q=#{city.city_name}"
      result = JSON.parse(HTTP.get(full_url))
      city.update(location_key: result[0]['Key'])
    end
  end

  def self.update_city_table
    access = new(Rails.application.credentials.weather_api_key)
    access.load_location_key
  end
end
