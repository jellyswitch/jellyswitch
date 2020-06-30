# typed: false
class AddInfoToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :snippet, :string, null: false, default: "Generic snippet about the space"
    add_column :operators, :background, :string, null: false, default: "defaultbackground.png"
    add_column :operators, :wifi_name, :string, null: false, default: "not set"
    add_column :operators, :wifi_password, :string, null: false, default: "not set"
    add_column :operators, :building_address, :string, null: false, default: "not set"
    add_column :operators, :logo, :string, null: false, default: "logo.png"
    add_column :operators, :approval_required, :boolean, null: false, default: true
  end
end