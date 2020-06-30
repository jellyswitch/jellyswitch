# typed: true
class Billing::Subscription::SaveSubscription
  include Interactor

  delegate :subscription, :user, :start_day, to: :context

  def call
    unless user.card_added? || user.out_of_band? || user.bill_to_organization?
      context.fail!(message: "Can't add a subscription for someone with no billing info on file.")
    end

    subscription.billable = BillableFactory.for(subscription).billable
    subscription.start_date = start_day

    if subscription.save
      context.subscription = subscription
    else
      context.fail!(message: "There was a problem creating this subscription.")
    end
  end

  def rollback
    context.subscription.destroy
  end
end
