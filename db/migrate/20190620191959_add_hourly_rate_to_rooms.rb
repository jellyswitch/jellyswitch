class AddHourlyRateToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :rentable, :boolean, null: false, default: false
    add_column :rooms, :hourly_rate_in_cents, :integer, null: false, default: 0
  end
end
