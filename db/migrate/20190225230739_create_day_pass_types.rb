# typed: true
class CreateDayPassTypes < ActiveRecord::Migration[5.2]
  def change
    create_table :day_pass_types do |t|
      t.string :name, null: false
      t.integer :operator_id, null: false
      t.string :stripe_sku_id
      t.integer :amount_in_cents, null: false, default: 0
      t.boolean :available, null: false, default: true
      t.boolean :visible, null: false, default: true

      t.timestamps
    end
  end
end
