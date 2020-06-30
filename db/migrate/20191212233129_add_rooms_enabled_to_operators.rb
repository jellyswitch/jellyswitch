class AddRoomsEnabledToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :rooms_enabled, :boolean, null: false, default: true
  end
end
