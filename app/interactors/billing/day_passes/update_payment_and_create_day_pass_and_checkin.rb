# typed: false
class Billing::DayPasses::UpdatePaymentAndCreateDayPassAndCheckin
  include Interactor::Organizer

  organize(
    Billing::DayPasses::SaveDayPass,
    Billing::Payment::UpdateUserPayment,
    Billing::DayPasses::CreateStripeInvoice,
    Checkins::AutoCheckin,
    CreateNotifications
  )
end
