class AddOfficesEnabledToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :offices_enabled, :boolean, null: false, default: true
  end
end
