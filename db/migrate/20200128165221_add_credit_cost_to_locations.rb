class AddCreditCostToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :credit_cost_in_cents, :integer, null: false, default: 0
  end
end
