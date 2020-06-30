# typed: false
class AddInvoiceIdToDayPass < ActiveRecord::Migration[5.2]
  def change
    add_column :day_passes, :invoice_id, :integer
  end
end
