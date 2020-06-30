# typed: true
class Billing::DayPasses::CreateStripeInvoice
  include Interactor

  delegate :day_pass, :token, :operator, :out_of_band, :params, :user_id, :user, to: :context

  def call
    @invoice_item = Stripe::InvoiceItem.create({
      customer: day_pass.billable.stripe_customer_id,
      currency: 'usd',
      amount: day_pass.day_pass_type.amount_in_cents,
      description: day_pass.charge_description
    }, {
      api_key: operator.stripe_secret_key,
      stripe_account: operator.stripe_user_id
    })

    invoice_args = DayPassableFactory.for(day_pass).invoice_args
    @invoice = Stripe::Invoice.create(
      invoice_args,
      {
        api_key: operator.stripe_secret_key,
        stripe_account: operator.stripe_user_id
      }
    )

    result = CreateInvoice.call(stripe_invoice: @invoice)
    if !result.success?
      context.fail!(message: result.message)
    end

    day_pass.invoice_id = result.invoice.id
    if !day_pass.save
      context.fail!(message: "There was a problem invoicing this day pass.")
    end

    context.day_pass = day_pass
    context.notifiable = day_pass
  end
end