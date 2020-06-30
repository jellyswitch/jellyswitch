class Childcare::CreateReservation
  include Interactor::Organizer

  organize(
    Childcare::SaveReservation,
    Childcare::ChargeCredits,
    Childcare::SendConfirmation,
    CreateNotifications
  )
end