# typed: false
require 'rails_helper'

RSpec.describe Refundable::RefundableInvoice do
  let(:operator) { create(:operator) }
  let(:user) { create(:user, :with_stripe_info, operator: operator) }
  let(:plan) { create(:plan, operator: operator) }
  let(:subscription) { create(:subscription, :with_stripe_info, plan: plan) }
  let(:invoice) do
    stripe_invoice = operator.create_stripe_invoice(user)
    stripe_invoice.status = 'paid'

    create(:invoice,
      billable: user,
      operator: operator,
      amount_due: stripe_invoice.amount_due.to_i,
      amount_paid: stripe_invoice.amount_paid.to_i,
      stripe_invoice_id: stripe_invoice.id,
      date: Time.current,
      due_date: Time.at(stripe_invoice.due_date).to_datetime,
      status: stripe_invoice.status
    )
  end

  subject(:refundable_invoice) { described_class.new(invoice) }

  describe '#cancel' do
    it 'creates a Stripe refund, a Refund record and updates the invoice status' do
      refundable_invoice.cancel

      expect { refundable_invoice.cancel }.to change { Refund.count }.by(1)

      expect(refundable_invoice.status).to eq('refunded')
    end
  end
end
