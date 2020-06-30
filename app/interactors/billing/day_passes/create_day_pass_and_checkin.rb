# typed: false
class Billing::DayPasses::CreateDayPassAndCheckin
  include Interactor::Organizer

  organize(
    Billing::DayPasses::SaveDayPass,
    Billing::DayPasses::CreateStripeInvoice,
    Checkins::AutoCheckin,
    CreateNotifications
  )
end
