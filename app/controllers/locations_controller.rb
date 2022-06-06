# frozen_string_literal: true

class LocationsController < ApplicationController
  def update_city_name
    file_path = "#{Rails.root}/cities.txt"
    file = File.open(file_path) if File.exist?(file_path)
    cities = file.readlines.map(&:chomp)
    file.close

    cities.each do |city|
      location = Location.new(city_name: city)
      location.save
    end
    render plain: 'You have fill/update the locations table, city_name column'
  end

  def update_location_key
    resourse_url = 'http://dataservice.accuweather.com/locations/v1/cities/search'
    cities = Location.where(location_key: nil)

    render plain: 'All cities are already updated' if cities.blank?

    cities.each do |city|
      query = "#{resourse_url}?apikey=#{api_key}&q=#{city.city_name}"
      json = JSON.parse(HTTP.get(query))
      city.update(location_key: json[0]['Key'])
    end
    render plain: 'Location_key for cities are updated'
  end

  private

  def api_key
    Rails.application.credentials.weather_api_key
  end
end
