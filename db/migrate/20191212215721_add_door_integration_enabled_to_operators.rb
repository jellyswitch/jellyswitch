class AddDoorIntegrationEnabledToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :door_integration_enabled, :boolean, null: false, default: true
  end
end
