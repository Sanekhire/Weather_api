# frozen_string_literal: true

Rails.application.routes.draw do
  root 'forecasts#health'

  get '/locations/:id/weather/current', to: 'forecasts#current_temp'

  get '/locations/:id/weather/historical', to: 'forecasts#historical'

  get '/locations/:id/weather/historical/max', to: 'forecasts#max_temp'

  get '/locations/:id/weather/historical/min', to: 'forecasts#min_temp'

  get '/locations/:id/weather/historical/avg', to: 'forecasts#average_temp'

  get '/locations/:id/weather/by_time', to: 'forecasts#by_time'

  get '/health', to: 'forecasts#health'

  get '/locations/update_location_key', to: 'locations#update_location_key'

  get '/locations/update_city_name', to: 'locations#update_city_name'
end
