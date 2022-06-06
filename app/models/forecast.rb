# frozen_string_literal: true

class Forecast < ApplicationRecord
  include Weather
  scope :temp24, -> { select(:date, :temp).order(date: :desc).limit(24) }

  belongs_to :location
  validates :date, presence: true
  validates :temp, presence: true
end
