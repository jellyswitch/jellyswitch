# typed: false
class UpdateInvoiceStatus
  include Interactor

  delegate :stripe_invoice, to: :context

  def call
    invoice = Invoice.find_by(stripe_invoice_id: stripe_invoice.id)
    if invoice.nil?
      context.fail!(message: "Can't find invoice #{stripe_invoice.id}")
    end

    new_status = stripe_invoice.status

    invoice.status = new_status

    if !invoice.save
      context.fail!(message: "Couldn't save invoice #{number} with new status: #{new_status}")
    end

    if invoice.paid?
      result = Billing::Invoices::AddCreditsToSubscribable.call(
        invoice: invoice
      )

      if !result.success?
        context.fail!(message: result.message)
      end
    end
  end
end