class ChildcareReservationPurchaseFactory
  def self.for(user)
    if user.out_of_band?
      ChildcareReservationPurchase::OutOfBand
    else
      ChildcareReservationPurchase::InBand
    end.new(user)
  end
end