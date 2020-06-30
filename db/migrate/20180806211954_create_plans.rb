# typed: true
class CreatePlans < ActiveRecord::Migration[5.2]
  def change
    create_table :plans do |t|
      t.string :interval, null: false
      t.integer :amount_in_cents, null: false
      t.string :name, null: false
      t.boolean :visible, null: false, default: true
      t.boolean :available, null: false, default: true
      t.string :slug

      t.timestamps
    end
  end
end
