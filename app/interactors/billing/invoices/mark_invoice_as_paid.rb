# typed: true
class Billing::Invoices::MarkInvoiceAsPaid
  include Interactor

  delegate :invoice, :operator, to: :context

  def call
    if operator.mark_invoice_paid(invoice, paid_out_of_band: true)
      invoice.update(status: 'paid')

      result = Billing::Invoices::AddCreditsToSubscribable.call(
        invoice: invoice
      )

      if !result.success?
        context.fail!(message: result.message)
      end
    else
      context.fail!(message: 'Failed to mark invoice as paid.')
    end
  end
end
