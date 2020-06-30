# typed: false
class RemoveSkuFromDayPassTypes < ActiveRecord::Migration[5.2]
  def change
    remove_column :day_pass_types, :stripe_sku_id
  end
end
