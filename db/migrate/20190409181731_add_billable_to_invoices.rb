# typed: false
class AddBillableToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_reference :invoices, :billable, polymorphic: true
  end
end
