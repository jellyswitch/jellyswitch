# typed: true
class CreateRefunds < ActiveRecord::Migration[5.2]
  def change
    create_table :refunds do |t|
      t.string :amount
      t.references :invoice, foreign_key: true
      t.references :user, foreign_key: true
      t.string :stripe_refund_id

      t.timestamps
    end
  end
end
