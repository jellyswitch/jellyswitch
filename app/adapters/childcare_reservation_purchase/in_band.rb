# typed: true
class ChildcareReservationPurchase::InBand < ChildcareReservationPurchase::DefaultChildcareReservationPurchase
  def invoice_args
    super.merge!(
      billing: 'charge_automatically'
    )
  end
end