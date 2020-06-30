# typed: false
class Billing::DayPasses::CreateFreeDayPass
  include Interactor::Organizer

  organize(
    Billing::DayPasses::FindFreeDayPass,
    Billing::DayPasses::SaveDayPass,
    Billing::DayPasses::CreateStripeInvoice,
    CreateNotifications
  )
end
