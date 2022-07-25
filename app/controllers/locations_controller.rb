# frozen_string_literal: true

class LocationsController < ApplicationController
  def show
    @cities = Location.all
    render json: @cities.as_json(only: :city_name)
  end
end
