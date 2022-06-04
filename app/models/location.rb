class Location < ApplicationRecord
    include Weather
    has_many :forecasts, dependent: :destroy
    validates :city_name, presence: true, uniqueness: true, length: { minimum: 2 }

    


end
