# typed: true
class Billing::Subscription::SetBillable
  include Interactor

  delegate :subscription, to: :context

  def call
    subscription.billable = BillableFactory.for(subscription).billable
  end

  def rollback
    subscription.billable = nil
  end
end