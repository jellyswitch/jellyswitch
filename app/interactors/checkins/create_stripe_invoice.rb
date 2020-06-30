# typed: true
class Checkins::CreateStripeInvoice
  include Interactor

  delegate :checkin, to: :context

  def call
    if generate_invoice?
      @invoice_item = Stripe::InvoiceItem.create({
        customer: checkin.billable.stripe_customer_id,
        currency: 'usd',
        amount: checkin.charge_amount,
        description: checkin.charge_description
      }, {
        api_key: checkin.location.operator.stripe_secret_key,
        stripe_account: checkin.location.operator.stripe_user_id
      })

      invoice_args = CheckInableFactory.for(checkin).invoice_args
      @invoice = Stripe::Invoice.create(
        invoice_args,
        {
          api_key: checkin.location.operator.stripe_secret_key,
          stripe_account: checkin.location.operator.stripe_user_id
        }
      )

      result = CreateInvoice.call(stripe_invoice: @invoice)
      if !result.success?
        context.fail!(message: result.message)
      end

      if !checkin.update(invoice_id: result.invoice.id)
        context.fail!(message: "There was a problem invoicing this day pass.")
      end
    end
  end

  private

  def generate_invoice?
    if checkin.user.operator.production? || checkin.user.operator.subdomain == "southlakecoworking"
      !(checkin.user.member?(checkin.location, day= checkin.datetime_in) ||
        checkin.user.has_active_day_pass? ||
        checkin.user.has_active_lease? ||
        checkin.user.admin?)
    else
      false
    end
  end
end