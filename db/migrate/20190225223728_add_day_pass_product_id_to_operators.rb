# typed: false
class AddDayPassProductIdToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :stripe_day_pass_product_id, :string
  end
end
