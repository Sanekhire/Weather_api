# frozen_string_literal: true

class ForecastsController < ApplicationController
  before_action :set_location, except: %i[health temp_check]

  def current_temp
    @current = query_with_choice('current')
    temp_check(@current)
  end

  def historical
    @historical24 = query_with_choice('historical')
    temp_check(@historical24)
  end

  def max_temp
    @max = query_with_choice('max')
    temp_check(@max)
  end

  def min_temp
    @min = query_with_choice('min')
    temp_check(@min)
  end

  def average_temp
    @avg = query_with_choice('avg')
    temp_check(@avg)
  end

  def by_time
    @temp_by_time = query_with_choice('by_time').as_json(except: :id)
    @temp_by_time.blank? ? (raise ActiveRecord::RecordNotFound) : (render json: @temp_by_time)
  end

  def health
    render status: :ok
  end

  def query_with_choice(choice)
    historical24_query = 'SELECT date, temp FROM forecasts WHERE location_id = ? ORDER BY date DESC LIMIT 24'

    case choice
    when 'historical'
      sql = [historical24_query, @location.id]
    when 'current'
      sql = ['SELECT date, temp FROM forecasts WHERE location_id = ? ORDER BY date DESC LIMIT 1', @location.id]
    when 'max'
      sql = ["SELECT date, MAX(temp) AS max FROM (#{historical24_query}) AS forecast", @location.id]
    when 'min'
      sql = ["SELECT date, MIN(temp) AS min FROM (#{historical24_query}) AS forecast", @location.id]
    when 'avg'
      sql = ["SELECT ROUND(AVG(temp),1) AS avg FROM (#{historical24_query}) AS forecast", @location.id]
    when 'by_time'
      input_date = params[:timestamp].to_i
      up_limit = input_date + 1800
      down_limit = input_date - 1800
      sql = [
        'SELECT date, temp FROM forecasts WHERE location_id = ? AND date BETWEEN ? AND ? ORDER BY date DESC LIMIT 1',
        @location.id, down_limit, up_limit
      ]
    end

    Forecast.find_by_sql(sql)
  end

  private

  def temp_check(temp)
    if temp.blank?
      raise(EmptyTempData,
            'No data! You have to update data first. Try  "WeatherData.load_data(city)" in console ')
    end

    render json: temp.as_json(except: :id)
  end

  def set_location
    @location = Location.find params[:id]
  end
end
