# typed: false
class AddDueDateToInvoices < ActiveRecord::Migration[5.2]
  def change
    add_column :invoices, :due_date, :datetime
  end
end
