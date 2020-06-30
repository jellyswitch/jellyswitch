# typed: true
class Billable::Subscription < SimpleDelegator
  attr_accessor :billable, :subscription

  def initialize(subscription)
    @subscription = subscription
  end

  def billable
    case @subscription.subscribable_type
    when "User"
      user
    when "Organization"
      # This is probably an office lease
      @subscription.subscribable
    end
  end

  private

  def user
    if subscription.subscribable.member_of_organization?
      if subscription.subscribable.bill_to_organization?
        subscription.subscribable.organization
      else
        subscription.subscribable
      end
    else
      subscription.subscribable
    end
  end
end