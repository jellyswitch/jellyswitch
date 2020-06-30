class AddCrmEnabledToOperators < ActiveRecord::Migration[6.0]
  def change
    add_column :operators, :crm_enabled, :boolean, null: false, default: false
  end
end
