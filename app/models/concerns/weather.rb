module Weather
    extend ActiveSupport::Concern
  
    
    included do

         def fill_table
          
            self.historical_data.each{|k, v| 
            forecast = self.forecasts.build(date: k, temp: v,)
            forecast.save
            }
                 
            
          end

          def update_table 
            first_date_forecast = Forecast.where(location_id: self.id).order(date: :desc).first.date
            self.historical_data.each{|k, v|
            forecast = self.forecasts.build(date: k,temp: v) 
            forecast.save if ((k.to_i - first_date_forecast.to_i) / 3600.0).round(1) > 0.9
            }
            
          end
          
        
          def current_temp
            resourse_url = "http://dataservice.accuweather.com/currentconditions/v1/"
            query = "#{resourse_url}#{self.location_key}?apikey=#{api_key}"
            json = JSON.parse(HTTP.get(query))
            current_temp = json[0]["Temperature"]["Metric"]["Value"]
            current_temp
          end
        
        
        def historical_data
            resourse_url = "http://dataservice.accuweather.com/currentconditions/v1/"
            query = "#{resourse_url}#{self.location_key}/historical/24?apikey=#{api_key}"
            json = JSON.parse(HTTP.get(query))
            historical_temp = {}
            json.each { 
              |hash, k, v| 
              k = DateTime.strptime(hash["LocalObservationDateTime"], "%Y-%m-%dT%H:%M:%S")
              v = hash["Temperature"]["Metric"]["Value"]

              historical_temp.merge!(k => v)
              }
              historical_temp
        end

       private

        def api_key
          Rails.application.credentials.weather_api_key
        end
    
  end
end