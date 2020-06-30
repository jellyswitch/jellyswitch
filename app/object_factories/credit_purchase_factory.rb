class CreditPurchaseFactory
  def self.for(user)
    if user.out_of_band?
      CreditPurchase::OutOfBand
    else
      CreditPurchase::InBand
    end.new(user)
  end
end