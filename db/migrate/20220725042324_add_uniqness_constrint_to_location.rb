# frozen_string_literal: true

class AddUniqnessConstrintToLocation < ActiveRecord::Migration[6.1]
  def change
    add_index :locations, :city_name, unique: true
  end
end
