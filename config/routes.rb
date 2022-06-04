Rails.application.routes.draw do
  root "locations#index"

  get "/locations/:id/weather/current", to: "forecasts#current"

  get "/locations/:id/weather/historical", to: "forecasts#historical"

  get "/locations/:id/weather/fill_table", to: "forecasts#fill_table"



end
