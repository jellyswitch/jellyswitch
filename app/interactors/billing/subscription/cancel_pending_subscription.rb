# typed: true
class Billing::Subscription::CancelPendingSubscription
  include Interactor
  
  delegate :subscription, to: :context

  def call
    if !subscription.destroy
      context.fail!(message: 'Unable to cancel subscription.')
    end
  end
end