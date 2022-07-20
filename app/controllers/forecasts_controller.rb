# frozen_string_literal: true

class ForecastsController < ApplicationController
  before_action :set_location, except: %i[health temp_check]

  def current
    forecast = @location.current_temp
    render json: forecast
  end

  def historical
    @historical24 = query_with_choice('historical').to_json
    temp_check(@historical24)
  end

  def max_temp
    @max = query_with_choice('max').to_json
    temp_check(@max)
  end

  def min_temp
    @min = query_with_choice('min').to_json
    temp_check(@min)
  end

  def average_temp
    @avg = query_with_choice('avg').to_json
    temp_check(@avg)
  end

  def by_time
    up_range = Time.zone.at(params[:timestamp].to_i + 1800).to_datetime
    down_range = Time.zone.at(params[:timestamp].to_i - 1800).to_datetime
    @temp_by_time = @location.forecasts.select(:date, :temp).where(date: down_range..up_range).order(date: :desc).first
    @temp_by_time.nil? ? (raise ActiveRecord::RecordNotFound) : (@temp_by_time.to_json)
  end

  def update_forecast
    if Forecast.find_by(location_id: @location.id).blank?
      @location.fill_table
    else
      @location.update_table
    end
  end

  def temp_check(temp)
    raise(EmptyTempData, 'You have to update data first. Try  "weather/update_forecast" ') if temp.blank?
    render json: temp
  end

  def query_with_choice(choice)
    main_sql_query = "SELECT date, temp FROM forecasts WHERE location_id = #{@location.id} ORDER BY date DESC LIMIT 24"

      case choice
      when 'historical'
        sql = main_sql_query
      when 'max' 
        sql = "SELECT MAX(temp) AS max FROM (#{main_sql_query}) AS forecast"
      when 'min'
        sql = "SELECT MIN(temp) AS min FROM (#{main_sql_query}) AS forecast"
      when 'avg'
        sql = "SELECT AVG(temp) AS avg FROM (#{main_sql_query}) AS forecast"

      end
      
    ActiveRecord::Base.connection.execute(sql)
  end

 
  private

  
  def set_location
    @location = Location.find params[:id]
  end
end
