# typed: true
class Billing::Invoices::ChargeInvoice
  include Interactor

  delegate :invoice, :operator, to: :context

  def call
    if operator.charge_invoice(invoice)
      invoice.update(status: 'paid')
    else
      context.fail!(message: 'Failed to mark invoice as paid.')
    end
  end
end