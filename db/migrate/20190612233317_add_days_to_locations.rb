# typed: false
class AddDaysToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :open_sunday, :boolean, null: false, default: false
    add_column :locations, :open_monday, :boolean, null: false, default: true
    add_column :locations, :open_tuesday, :boolean, null: false, default: true
    add_column :locations, :open_wednesday, :boolean, null: false, default: true
    add_column :locations, :open_thursday, :boolean, null: false, default: true
    add_column :locations, :open_friday, :boolean, null: false, default: true
    add_column :locations, :open_saturday, :boolean, null: false, default: false
  end
end
