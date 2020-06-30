# typed: true
class CreateSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :subscriptions do |t|
      t.integer :plan_id, null: false
      t.integer :user_id, null: false
      t.boolean :active, null: false, default: true

      t.timestamps
    end
  end
end
