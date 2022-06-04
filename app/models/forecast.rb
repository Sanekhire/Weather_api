class Forecast < ApplicationRecord

  include Weather
  
  belongs_to :location
  validates :date, presence: true
  validates :temp, presence: true



  

end
