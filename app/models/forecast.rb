class Forecast < ApplicationRecord
  include Weather
  scope :temp_24, -> { select(:date, :temp).order(date: :desc).limit(24) }
  
  belongs_to :location
  validates :date, presence: true
  validates :temp, presence: true

   

end
