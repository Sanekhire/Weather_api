class Forecast < ApplicationRecord
  scope :temp_24, -> { select(:date, :temp).order(date: :desc).limit(24) }
  include Weather
  
  belongs_to :location
  validates :date, presence: true
  validates :temp, presence: true



  

end
