# typed: true
class StripeSubscriptionFactory
  def self.for(subscription, lease)
    if subscription.billable.out_of_band?
      StripeSubscription::OutOfBand
    else
      StripeSubscription::InBand
    end.new(subscription, lease)
  end
end