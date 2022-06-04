class LocationsController < ApplicationController
  

  def index
    @locations = Location.order [created_at: :desc]
    render plain: @locations
  end

  
    
end
