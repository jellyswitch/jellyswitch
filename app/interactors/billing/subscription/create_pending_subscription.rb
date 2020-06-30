# typed: true
class Billing::Subscription::CreatePendingSubscription
  include Interactor
  include ErrorsHelper

  delegate :subscription, :user, :start_day, to: :context

  def call
    if !user.out_of_band? && !user.card_added?
      # create a pending subscription instead
      subscription.pending = true
      subscription.active = false
    end

    if user.subscriptions.pending.count > 0
      context.fail!(message: "Can't add more than one pending memberships. Cancel any existing pending memberships first, and try again.")
    end

    subscription.billable = BillableFactory.for(subscription).billable
    subscription.start_date = start_day

    if subscription.save
      context.subscription = subscription
    else
      context.fail!(message: "There was a problem creating this subscription (#{errors_for(subscription)}).")
    end
  end
end