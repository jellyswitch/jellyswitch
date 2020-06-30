class CreditPurchase::DefaultCreditPurchase < SimpleDelegator
  attr_accessor :user

  def initialize(user)
    @user = user
  end

  def invoice_args
    {
      customer: user.stripe_customer_id,
      auto_advance: true
    }
  end
end
