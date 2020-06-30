# typed: false
class AddHourlyRateToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :allow_hourly, :boolean, null: false, default: false
    add_column :locations, :hourly_rate_in_cents, :integer, null: false, default: 0
  end
end
