# typed: false
class MigrationInvoiceBillables < ActiveRecord::Migration[5.2]
  def change
    invoices = Invoice.all

    reversible do |dir|
      dir.up do
        invoices.each do |invoice|
          if invoice.user_id
            user = User.find(invoice.user_id)
            invoice.billable = user
            invoice.save!
          end
        end

        remove_reference :invoices, :user, index: true
      end

      dir.down do
        add_reference :invoices, :user, index: true, foreign_key: true

        invoices.each do |invoice|
          if invoice.billable_type == 'User'
            invoice.user_id = invoice.billable_id
            invoice.save!
          end
        end
      end
    end
  end
end
