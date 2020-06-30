# typed: false
class AddInitialInvoiceDateToOfficeLeases < ActiveRecord::Migration[5.2]
  def change
    add_column :office_leases, :initial_invoice_date, :date
  end
end
