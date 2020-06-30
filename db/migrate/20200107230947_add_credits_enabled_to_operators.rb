class AddCreditsEnabledToOperators < ActiveRecord::Migration[6.0]
  def change
    add_column :operators, :credits_enabled, :boolean, default: false, null: false
  end
end
