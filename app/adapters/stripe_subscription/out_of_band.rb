# typed: true
module StripeSubscription
  class OutOfBand < DefaultSubscription
    def subscription_args
      super.merge!(billing: 'send_invoice', days_until_due: 30)
    end
  end
end