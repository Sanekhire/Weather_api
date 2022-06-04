class RemoveTimeFromForecasts < ActiveRecord::Migration[6.1]
  def change
    remove_column :forecasts, :time, :datetime
  end
end
