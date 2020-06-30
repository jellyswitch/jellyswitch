# typed: false
# == Schema Information
#
# Table name: refunds
#
#  id               :bigint(8)        not null, primary key
#  amount           :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  invoice_id       :bigint(8)
#  stripe_refund_id :string
#
# Indexes
#
#  index_refunds_on_invoice_id  (invoice_id)
#
# Foreign Keys
#
#  fk_rails_...  (invoice_id => invoices.id)
#

require 'rails_helper'

RSpec.describe Refund, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end
