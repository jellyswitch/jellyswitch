# typed: true
class CreateInvoice
  include Interactor

  delegate :stripe_invoice, :created_at, to: :context

  def call
    invoice = Invoice.find_by(stripe_invoice_id: stripe_invoice.id)
    if invoice.present?
      context.fail!(message: "Invoice #{invoice.number} already exists")
    end

    customer = stripe_invoice.customer

    # TODO: put type in stripe invoice metadata
    billable = User.find_by(stripe_customer_id: customer) || Organization.find_by(stripe_customer_id: customer)

    if billable.nil?
      context.fail!(message: "Cannot find billable with stripe customer id #{customer}")
    end

    invoice_date = Time.at(stripe_invoice.created).to_datetime

    due_date = nil
    if stripe_invoice.due_date.present?
      due_date = Time.at(stripe_invoice.due_date).to_datetime
    end

    params = {
      billable: billable,
      operator_id: billable.operator.id,
      amount_due: stripe_invoice.amount_due.to_i,
      amount_paid: stripe_invoice.amount_paid.to_i,
      number: stripe_invoice.number,
      stripe_invoice_id: stripe_invoice.id,
      date: invoice_date,
      due_date: due_date,
      status: stripe_invoice.status
    }

    if created_at.present?
      params[:created_at] = created_at
      params[:updated_at] = created_at
    end

    invoice = Invoice.create!(params)

    context.invoice = invoice

    result = Billing::Invoices::AddCreditsToSubscribable.call(
      invoice: invoice
    )

    if !result.success?
      context.fail!(message: result.message)
    end
  end
end
