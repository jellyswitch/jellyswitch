# typed: false
# == Schema Information
#
# Table name: invoices
#
#  id                :bigint(8)        not null, primary key
#  amount_due        :integer
#  amount_paid       :integer
#  billable_type     :string
#  date              :datetime
#  due_date          :datetime
#  number            :string
#  status            :string
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  billable_id       :bigint(8)
#  operator_id       :integer
#  stripe_invoice_id :string
#
# Indexes
#
#  index_invoices_on_billable_type_and_billable_id  (billable_type,billable_id)
#

require 'rails_helper'

RSpec.describe Invoice, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
