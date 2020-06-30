class SubscriptionDeleted::AlreadyCancelled < SimpleDelegator
  attr_accessor :subscription

  def initialize(subscription)
    @subscription = subscription
  end

  def perform
    @result = subscription.update(active: false)
    self
  end

  def success?
    @result
  end

  def message
    "AlreadyCancelled::Message for #{subscription.stripe_subscription_id}"
  end
end