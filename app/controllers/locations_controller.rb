class LocationsController < ApplicationController
  

 
  def update_city_name
    file = File.open("#{Rails.root}/cities.txt") if File.exist?("#{Rails.root}/cities.txt")
    cities = file.readlines.map(&:chomp)
    cities.each {|city| 
    location = Location.new(city_name: city)
    location.save
    }
    render plain: "You have fill/update the locations table, city_name column"
        
  end

  def update_location_key
    resourse_url = "http://dataservice.accuweather.com/locations/v1/cities/search"
    cities = Location.where(location_key: nil)
    
    render plain: "All cities are already updated" if  cities.blank?
  
    cities.each {|city| 
    query = "#{resourse_url}?apikey=#{api_key}&q=#{city.city_name}"
    json = JSON.parse(HTTP.get(query))
    city.update_column(:location_key, json[0]["Key"])
    }
    render plain: "Location_key for cities are updated"
    
  end

  private
  def api_key
    Rails.application.credentials.weather_api_key
  end
  
    
end
