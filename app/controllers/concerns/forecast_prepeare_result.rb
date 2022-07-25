# frozen_string_literal: true

module ForecastPrepeareResult
  extend ActiveSupport::Concern

  included do
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

    def temp_check(temp)
      if temp.blank?
        raise EmptyDataError, 'Empty data! You have to update data first. ' \
                              "Try WeatherData.load_data(#{params[:city_name]}) in console "
      end
    rescue StandardError => e
      render json: e.message.to_json
    else
      render json: temp.as_json(except: :id)
    end
  end
end
