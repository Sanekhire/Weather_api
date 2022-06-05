module Weather
    extend ActiveSupport::Concern
  
    
    included do

       
         
         def take_location_key
            resourse_url = "http://dataservice.accuweather.com/locations/v1/cities/search"
            query = "#{resourse_url}?apikey=#{api_key}&q=#{self.city_name}"
            json = JSON.parse(HTTP.get(query))
            json[0]["Key"]
         end

         def fill_table(location) 
          
            location.historical_data.each{|k, v| 
            forecast = location.forecasts.build(set_param_forecast(k, v,))
            forecast.save
            }
                 
            render plain: "you fill the table, now you can take the historical data"
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
              k = DateTime.strptime(hash["LocalObservationDateTime"], "%Y-%m-%dT%H:%M:%S")
              v = hash["Temperature"]["Metric"]["Value"]

              @historical_temp.merge!(k => v)
              }
              @historical_temp
        end

       
         def api_key
            Rails.application.credentials.weather_api_key
         end
    
  end
end