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
    @temp_by_time.blank? ? (raise ActiveRecord::RecordNotFound) : (render json: @temp_by_time)
  end

  def health
    head :ok
  end

  private

  def set_location
    @location = Location.find_by(city_name: params[:city_name])
    if @location.nil?
      raise EmptyDataError, 'Empty data! Check the city name. It must be like: Mariupol. ' \
                            'Check if there is a location on main page'
    end
  rescue StandardError => e
    render json: e.message.to_json
  end
end
