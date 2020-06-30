# typed: false
class AddDayPassCostToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :day_pass_cost_in_cents, :integer, null: false, default: 2500
  end
end
