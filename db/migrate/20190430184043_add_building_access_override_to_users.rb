# typed: false
class AddBuildingAccessOverrideToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :always_allow_building_access, :boolean, null: false, default: false
  end
end
