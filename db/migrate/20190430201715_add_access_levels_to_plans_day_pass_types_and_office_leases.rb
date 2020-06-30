# typed: false
class AddAccessLevelsToPlansDayPassTypesAndOfficeLeases < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :always_allow_building_access, :boolean, null: false, default: true
    add_column :day_pass_types, :always_allow_building_access, :boolean, null: false, default: false
    add_column :office_leases, :always_allow_building_access, :boolean, null: false, default: true
  end
end
