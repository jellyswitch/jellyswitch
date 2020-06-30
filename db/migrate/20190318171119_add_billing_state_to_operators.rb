# typed: false
class AddBillingStateToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :billing_state, :string, null: false, default: "demo"
  end
end
