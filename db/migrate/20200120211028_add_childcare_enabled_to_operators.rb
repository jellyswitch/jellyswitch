class AddChildcareEnabledToOperators < ActiveRecord::Migration[6.0]
  def change
    add_column :operators, :childcare_enabled, :boolean, null: false, default: false
  end
end
