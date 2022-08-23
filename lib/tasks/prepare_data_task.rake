# frozen_string_literal: true

require "#{Rails.root}/app/services/city_name"
require "#{Rails.root}/app/services/location_key"
require "#{Rails.root}/app/services/weather"

desc 'Fill tables with data to use in API'
task :prepare_data => :environment do

  CityName.load_data
  LocationKey.load_to_city
  Weather.load_data

end
