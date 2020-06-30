# typed: true
class Billing::Payment::CreateStripeCustomer
  include Interactor

  delegate :billable, :operator, to: :context

  def call
    return if billable.stripe_customer_id
    stripe_customer = operator.create_stripe_customer(billable)
    billable.update(stripe_customer_id: stripe_customer.id)
  end
end
