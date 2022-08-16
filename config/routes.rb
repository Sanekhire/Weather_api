# frozen_string_literal: true

Rails.application.routes.draw do
  root 'locations#show'

  get '/locations/:city_name/weather/current', to: 'forecasts#current_temp'

  get '/locations/:city_name/weather/historical', to: 'forecasts#historical'

  get '/locations/:city_name/weather/historical/max', to: 'forecasts#max_temp'

  get '/locations/:city_name/weather/historical/min', to: 'forecasts#min_temp'

  get '/locations/:city_name/weather/historical/avg', to: 'forecasts#average_temp'

  get '/locations/:city_name/weather/by_time', to: 'forecasts#by_time'

  get '/health', to: 'forecasts#health'
end
