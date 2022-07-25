# frozen_string_literal: true

class Location < ApplicationRecord
  has_many :forecasts, dependent: :destroy
  validates :city_name, presence: true, uniqueness: true, length: { minimum: 2 }
end
