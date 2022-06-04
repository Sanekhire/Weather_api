module Weather
    extend ActiveSupport::Concern
  
    
    included do

        def correct_city_url

            self.city_name.gsub(' ', '%20')
          end
         
         def take_location_key
            resourse_url = "http://dataservice.accuweather.com/locations/v1/cities/search"
            query = "#{resourse_url}?apikey=#{api_key}&q=#{correct_city_url}"
            json = JSON.parse(HTTP.get(query))
            json[0]["Key"]
         end
        
          def current_temp
            resourse_url = "http://dataservice.accuweather.com/currentconditions/v1/"
            query = "#{resourse_url}#{take_location_key}?apikey=#{api_key}"
            json = JSON.parse(HTTP.get(query))
            current_temp = json[0]["Temperature"]["Metric"]["Value"]
            current_temp
        end
        
        
        def historical_data
            resourse_url = "http://dataservice.accuweather.com/currentconditions/v1/"
            query = "#{resourse_url}#{take_location_key}/historical/24?apikey=#{api_key}"
            json = JSON.parse(HTTP.get(query))
            @historical_temp = {}
            json.each { 
              |hash, k, v| 
              k = hash["LocalObservationDateTime"].to_datetime
              v = hash["Temperature"]["Metric"]["Value"]

              @historical_temp.merge!(k => v)
              }
              @historical_temp
        end

       
          private
        
          
        
         def api_key
            'GRoH87noZyoYA7fjRoe11fD9VQQLdcwf'
         end
    
  end
end