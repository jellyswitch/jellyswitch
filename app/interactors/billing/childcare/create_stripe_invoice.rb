class Billing::Childcare::CreateStripeInvoice
  include Interactor

  delegate :amount, :user, :location, to: :context

  def call
    invoice_item = Stripe::InvoiceItem.create({
      customer: user.stripe_customer_id,
      currency: 'usd',
      amount: total_cost,
      description: "#{amount} credits at #{location.name}"
    }, {
      api_key: location.operator.stripe_secret_key,
      stripe_account: location.operator.stripe_user_id
    })

    invoice_args = ChildcareReservationPurchaseFactory.for(user).invoice_args
    @invoice = Stripe::Invoice.create(
      invoice_args,
      {
        api_key: location.operator.stripe_secret_key,
        stripe_account: location.operator.stripe_user_id
      }
    )

    result = CreateInvoice.call(stripe_invoice: @invoice)
    if !result.success?
      context.fail!(message: result.message)
    end
  end

  def total_cost
    amount * location.childcare_reservation_cost_in_cents
  end
end