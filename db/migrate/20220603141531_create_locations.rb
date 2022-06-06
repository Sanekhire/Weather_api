# frozen_string_literal: true

class CreateLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :locations do |t|
      t.string :city_name

      t.timestamps
    end
  end
end
