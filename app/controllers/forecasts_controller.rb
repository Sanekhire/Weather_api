# frozen_string_literal: true

class ForecastsController < ApplicationController
  before_action :set_location, except: %i[health temp_check]

  def current
    forecast = @location.current_temp
    render plain: forecast
  end

  def historical
    @historical24 = @location.forecasts.temp24
    warn_message if @historical24.blank?
  end

  def max_temp
    @max = @location.forecasts.temp24.maximum(:temp)
    temp_check(@max)
  end

  def min_temp
    @min = @location.forecasts.temp24.minimum(:temp)
    temp_check(@min)
  end

  def average_temp
    @avg = @location.forecasts.temp24.average(:temp)
    @avg.blank? ? warn_message : (render plain: @avg.round)
  end

  def by_time
    up_range = Time.zone.at(params[:timestamp].to_i + 1800).to_datetime
    down_range = Time.zone.at(params[:timestamp].to_i - 1800).to_datetime
    @temp_by_time = @location.forecasts.where(date: down_range..up_range).order(date: :desc).first
    @temp_by_time.nil? ? not_found : (render plain: "date: #{@temp_by_time.date}  temp:#{@temp_by_time.temp}")
  end

  def update_forecast
    if Forecast.find_by(location_id: @location.id).blank?
      @location.fill_table
      render plain: 'you fill the table, now you can take the historical data'

    else
      @location.update_table
      render plain: 'table is up to date'
    end
  end

  def temp_check(temp)
    temp.blank? ? warn_message : (render plain: temp)
  end

  private

  def warn_message
    render plain: 'You have to update data first. Try  "weather/update_forecast" '
  end

  def set_location
    @location = Location.find params[:id]
  end
end
