# frozen_string_literal: true

module Weather
  extend ActiveSupport::Concern

  included do
    def fill_table
      historical_data.each do |k, v|
        forecast = forecasts.build(date: k, temp: v)
        forecast.save
      end
    end

    def update_table
      first_date_forecast = Forecast.where(location_id: id).order(date: :desc).first.date
      historical_data.each do |k, v|
        forecast = forecasts.build(date: k, temp: v)
        forecast.save if ((k.to_i - first_date_forecast.to_i) / 3600.0).round(1) > 0.9
      end
    end

    def current_temp
      resourse_url = 'http://dataservice.accuweather.com/currentconditions/v1/'
      query = "#{resourse_url}#{location_key}?apikey=#{api_key}"
      json = JSON.parse(HTTP.get(query))
      json[0]['Temperature']['Metric']['Value']
    end

    def historical_data
      resourse_url = 'http://dataservice.accuweather.com/currentconditions/v1/'
      query = "#{resourse_url}#{location_key}/historical/24?apikey=#{api_key}"
      json = JSON.parse(HTTP.get(query))
      historical_temp = {}
      json.each do |hash, k, v|
        k = DateTime.strptime(hash['LocalObservationDateTime'], '%Y-%m-%dT%H:%M:%S')
        v = hash['Temperature']['Metric']['Value']

        historical_temp.merge!(k => v)
      end
      historical_temp
    end

    private

    def api_key
      Rails.application.credentials.weather_api_key
    end
  end
end
