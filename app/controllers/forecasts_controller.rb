# frozen_string_literal: true

class ForecastsController < ApplicationController
  include ForecastPrepeareResult
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
    if @temp_by_time.blank?
      (render file: 'public/404.html', status: :not_found,
              layout: false)
    else
      (render json: @temp_by_time)
    end
  end

  def health
    head :ok
  end

  private

  def set_location
    @location = Location.find_by(city_name: params[:city_name].capitalize)
    begin
      raise EmptyDataError if @location.nil?
    rescue StandardError => e
      render json: e.message.to_json
    end
  end
end
