# frozen_string_literal: true

class Location < ApplicationRecord
  
  has_many :forecasts, dependent: :destroy
  validates :city_name, presence: true, uniqueness: true, length: { minimum: 2 }
  before_save :check_amount_locations

  private

  def check_amount_locations
     throw :abort if Location.count >= 10
    
  end
end
