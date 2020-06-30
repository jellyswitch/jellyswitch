# typed: true
class CancelSubscription
  include Interactor

  def call
    subscription = context.subscription

    subscription.active = false

    if !subscription.save
      context.fail!(message: "Unable to cancel subscription.")
    end

    begin
      if subscription.stripe_subscription.status == "canceled"
        Rollbar.error("Warning: CancelSubscription called with Subscription: #{subscription.id} / #{subscription.stripe_subscription_id}")
      else
        subscription.cancel_stripe!
      end
    rescue Exception => e
      undo_deactivate(subscription)
      Rollbar.error("Interactor Failure: #{e.message}")
      context.fail!(message: e.message)
    end
  end

  def undo_deactivate(subscription)
    subscription.active = true
    if !subscription.save
      context.fail!(message: "Unable to cancel subscription. Your account may not be in good standing -- please contact support.")
    end
  end
end