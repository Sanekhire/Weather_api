class ForecastsController < ApplicationController
  
  before_action :set_location, only: [:current, :historical, :fill_table]
       
    
  def current
   
    @forecast = @location.current_temp
    render plain:  @forecast
  end

 

  def fill_table 
    if Forecast.find_by(location_id: @location.id).blank?
      @location.historical_data.each{|k, v| 
      forecast = @location.forecasts.build(set_param_forecast(k, v,))
      forecast.save
      }
      
      
      render plain: "you fill the table, now you can take the historical data"
    else
      render plain: "The data is already created"
      
    end
    
  end

  
  
  private

  def set_location
    @location = Location.find params[:id]
  end

  def set_param_forecast(date, temp)
    return{date: date, temp: temp}
  end

  
  



end
