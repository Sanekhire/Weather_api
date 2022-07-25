# frozen_string_literal: true

class ChangeColumnTypeInForecasts < ActiveRecord::Migration[6.1]
  def change
    change_column(:forecasts, :date, :integer)
  end
end
