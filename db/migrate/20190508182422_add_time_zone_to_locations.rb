# typed: false
class AddTimeZoneToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :time_zone, :string, default: "Pacific Time (US & Canada)", null: false
  end
end
