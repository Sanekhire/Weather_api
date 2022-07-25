# frozen_string_literal: true

class Forecast < ApplicationRecord
  belongs_to :location
  validates :date, presence: true
  validates :temp, presence: true
end
