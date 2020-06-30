# typed: true
require 'stripe'

module StripeMock
  def self.mock_stripe
    Stripe.api_key = "sk_test_123"
    Stripe.api_base = "http://localhost:12111"
  end
end

StripeMock.mock_stripe
