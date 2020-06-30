# typed: true
class Billing::Subscription::ActivateSubscription
  include Interactor

  delegate :subscription, :user, to: :context

  def call
    unless user.has_billing? || user.out_of_band?
      context.fail!(message: "Can't activate a subscription for someone with no billing info on file.")
    end

    subscription.active = true
    subscription.pending = false

    if subscription.start_date.past?
      subscription.start_date = Time.zone.now + 2.hours
    end

    if subscription.save
      context.subscription = subscription
    else
      context.fail!(message: "There was a problem activating this subscription.")
    end
  end
end
