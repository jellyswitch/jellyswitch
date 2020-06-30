class SubscriptionDeleted::OfficeLease < SimpleDelegator
  attr_accessor :subscription

  def initialize(subscription)
    @subscription = subscription
  end

  def perform
    Billing::Leasing::TerminateOfficeLease.call(
      office_lease: subscription.office_leases.first,
      subscription: subscription
    )
  end
end