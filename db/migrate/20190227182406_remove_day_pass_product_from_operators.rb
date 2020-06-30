# typed: false
class RemoveDayPassProductFromOperators < ActiveRecord::Migration[5.2]
  def change
    remove_column :operators, :stripe_day_pass_product_id
  end
end
