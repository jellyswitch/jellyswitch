# typed: true
class MarkCustomerAsOutOfBand
  include Interactor

  def call
    user = context.user
    
    user.subscriptions.active.each do |subscription|
      stripe_subscription = subscription.stripe_subscription
      stripe_subscription.billing = "send_invoice"
      stripe_subscription.days_until_due = 30
      stripe_subscription.save
    end

    user.out_of_band = true
    if !user.save
      context.fail!(message: "Unable to save user record.")
    end
  end
end