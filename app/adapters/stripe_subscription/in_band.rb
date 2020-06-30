# typed: true
module StripeSubscription
  class InBand < DefaultSubscription
    def subscription_args
      super.merge!(billing: 'charge_automatically')
    end
  end
end