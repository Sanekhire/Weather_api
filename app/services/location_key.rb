# frozen_string_literal: true

class LocationKey
  def initialize(apikey)
    @apikey = apikey
  end

  def load_from_site
    resourse_url = 'http://dataservice.accuweather.com/locations/v1/cities/search'
    cities = Location.where(location_key: nil)

    cities.each do |city|
      full_url = "#{resourse_url}?apikey=#{@apikey}&q=#{city.city_name}"
      result = JSON.parse(HTTP.get(full_url))
      begin
        raise EmptyDataError if result.blank?
      rescue StandardError => e
        Rails.logger.debug e.message
      else
        city.update(location_key: result[0]['Key'])
      end
    end
  end

  def self.load_keys
    access = new(Rails.application.credentials.weather_api_key)
    access.load_from_site
  end
end
