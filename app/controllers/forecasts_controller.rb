class ForecastsController < ApplicationController
   
  before_action :set_location, except: :health
       
    
  def current
    @forecast = @location.current_temp
    render plain:  @forecast
  end

  def historical
    @historical_24 = @location.forecasts.temp_24
    
  end

  def max_temp
    @max = @location.forecasts.temp_24.maximum(:temp)
    render plain: @max
  end

  def min_temp
    @min = @location.forecasts.temp_24.minimum(:temp)
    render plain: @min
  end

  def average_temp
    @average = @location.forecasts.temp_24.average(:temp).round
    render plain: @average
  end

  def by_time
    
    up_range = Time.at(params[:timestamp].to_i + 1800).to_datetime
    down_range = Time.at(params[:timestamp].to_i - 1800).to_datetime
    @temp_by_time = @location.forecasts.where(:date => down_range..up_range).order(date: :desc).first
    @temp_by_time == nil ? not_found : (render plain: @temp_by_time.temp)
    
    
  end

  def update_forecast
     if Forecast.find_by(location_id: @location.id).blank?
      fill_table(@location) 
     else
      first_date_forecast = Forecast.where(location_id: @location.id).order(date: :desc).first.date
      @location.historical_data.each{|k, v|
      forecast = @location.forecasts.build(forecast_param(k, v))  
      forecast.save if ((k.to_i - first_date_forecast.to_i) / 3600.0).round(1) > 0.9
      }
      render plain: "table is up to date"
     end
  end

  
  

  
  
  private

  def set_location
    @location = Location.find params[:id]
  end


  def forecast_param(date, temp)
    return{date: date, temp: temp}
  end 

  
end
