# typed: false
class AddVisibleToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :visible, :boolean, default: true, null: false
  end
end
