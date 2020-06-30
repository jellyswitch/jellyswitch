# typed: true
class Billing::SubscriptionSync
  def self.call(subscription_id:, start_date: nil)
    subscription = Subscription.find(subscription_id)
    user = subscription.subscribable
    operator = user.operator

    stripe_subscription = operator.create_stripe_subscription(user, subscription, start_date)

    if stripe_subscription
      subscription.stripe_subscription_id = stripe_subscription.id
      subscription.save!
    end
  end
end
