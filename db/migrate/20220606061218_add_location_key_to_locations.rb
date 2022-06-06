# frozen_string_literal: true

class AddLocationKeyToLocations < ActiveRecord::Migration[6.1]
  def change
    add_column :locations, :location_key, :string
  end
end
