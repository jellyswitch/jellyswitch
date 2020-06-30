# typed: false
require 'rails_helper'

RSpec.shared_examples 'paying invoice' do |trait|
  describe '#call' do
    context "#{trait}" do
      let(:invoice) { create(:invoice, trait) }
      let(:operator) { invoice.operator }
      let(:context) { described_class.call(invoice: invoice, operator: operator) }

      context 'when successful' do
        before do
          expect(operator).to receive(:mark_invoice_paid).once.with(invoice, paid_out_of_band: true) { true }
        end

        it 'marks the invoice as paid' do
          expect(context).to be_a_success
          expect(invoice.status).to eq 'paid'
        end
      end

      context 'when unsuccessful' do
        before do
          allow(operator).to receive(:mark_invoice_paid).once.with(invoice, paid_out_of_band: true) { false }
        end

        it 'does not mark the invoice as paid' do
          expect(context).to be_a_failure
          expect(invoice.status).to_not eq 'paid'
        end
      end
    end
  end
end

RSpec.describe Billing::Invoices::MarkInvoiceAsPaid do
  include_examples 'paying invoice', 'with_user'
  include_examples 'paying invoice', 'with_organization'
end
