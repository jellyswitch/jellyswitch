class Billing::Reservations::UpdateBillingAndCreateRoomReservation
  include Interactor::Organizer

  organize(
    Billing::Payment::UpdateUserPayment,
    Billing::Reservations::SaveRoomReservation,
    Billing::Reservations::SaveStripeInvoice
  )
end