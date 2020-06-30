# typed: true
class CreateInvoices < ActiveRecord::Migration[5.2]
  def change
    create_table :invoices do |t|
      t.string :stripe_invoice_id
      t.integer :user_id
      t.integer :amount_due
      t.integer :amount_paid
      t.datetime :date
      t.string :status
      t.string :number
      t.integer :operator_id

      t.timestamps
    end
  end
end
