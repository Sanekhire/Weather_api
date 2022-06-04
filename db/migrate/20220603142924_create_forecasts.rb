class CreateForecasts < ActiveRecord::Migration[6.1]
  def change
    create_table :forecasts do |t|
      t.datetime :date
      t.datetime :time
      t.float :temp
      t.belongs_to :location, null: false, foreign_key: true

      t.timestamps
    end
  end
end
