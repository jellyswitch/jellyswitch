# typed: true
class Billing::Subscription::CreateStripeSubscription
  include Interactor
  delegate :subscription, :operator, :start_day, to: :context

  def call
    user = subscription.subscribable
    begin
      stripe_subscription = operator.create_stripe_subscription(subscription)
    rescue StandardError => e
      context.fail!(message: e.message)
    end

    if subscription.update(stripe_subscription_id: stripe_subscription.id)
      context.notifiable = subscription
    else
      context.fail!(message: "Could not save subscription.")
    end
    
  end
end
