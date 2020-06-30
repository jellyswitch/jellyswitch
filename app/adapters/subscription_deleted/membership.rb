class SubscriptionDeleted::Membership < SimpleDelegator
  attr_accessor :subscription

  def initialize(subscription)
    @subscription = subscription
  end

  def perform
    CancelSubscription.call(subscription: subscription)
  end
end