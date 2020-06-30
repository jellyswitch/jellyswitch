class Billing::Reservations::CreateRoomReservation
  include Interactor::Organizer
  
  organize(
    Billing::Reservations::SaveRoomReservation,
    Billing::Reservations::ChargeCredits,
    Billing::Reservations::SaveStripeInvoice,
    CreateNotifications
  )
end