# frozen_string_literal: true

class LocationKey
  def initialize(apikey)
    @apikey = apikey
  end

  def access_to_site(city)
    resourse_url = 'http://dataservice.accuweather.com/locations/v1/cities/search'
    full_url = "#{resourse_url}?apikey=#{@apikey}&q=#{city.city_name}"
    JSON.parse(HTTP.get(full_url))
  end

  def self.load_to_city
    client = new(Rails.application.credentials.weather_api_key)
    Location.where(location_key: nil).each do |city|
      result = client.access_to_site(city)
      begin
        raise EmptyDataError if result.blank?
      rescue EmptyDataError => e
        Rails.logger.debug e.message
      else
        city.update(location_key: result[0]['Key'])
      end
    end
  end
end
