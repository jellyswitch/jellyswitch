class ChildcareReservationPurchase::OutOfBand < ChildcareReservationPurchase::DefaultChildcareReservationPurchase
  def invoice_args
    super.merge!(
      billing: 'send_invoice',
      days_until_due: 30
    )
  end
end