class ForecastsController < ApplicationController
   
  before_action :set_location, except: :health
       
    
  def current
    @forecast = @location.current_temp
    render plain:  @forecast
  end

  def historical
    @temp = @location.forecasts.temp_24
    temp_check
  end

  def max_temp
    @temp = @location.forecasts.temp_24.maximum(:temp)
    temp_check
    
  end

  def min_temp
    @temp = @location.forecasts.temp_24.minimum(:temp)
    temp_check
  end

  def average_temp
    @temp = @location.forecasts.temp_24.average(:temp)
    @temp.nil? ? warn_message : (render plain: @temp.round)
    
  end

  def by_time
    
    up_range = Time.at(params[:timestamp].to_i + 1800).to_datetime
    down_range = Time.at(params[:timestamp].to_i - 1800).to_datetime
    @temp_by_time = @location.forecasts.where(:date => down_range..up_range).order(date: :desc).first
    @temp_by_time == nil ? not_found : (render plain: @temp_by_time.temp)
    
    
  end

  def update_forecast
     if Forecast.find_by(location_id: @location.id).blank? 
       @location.fill_table 
       render plain: "you fill the table, now you can take the historical data"
         
     else
      @location.update_table
      render plain: "table is up to date"
     end
  end

  def temp_check
    @temp.nil? ?  warn_message : (render plain: @temp)
  end
  
  private

  def warn_message
    render plain: "You have to update data first. Try  \"weather/update_forecast\" "
  end

  def set_location
    @location = Location.find params[:id]
  end

  
end
