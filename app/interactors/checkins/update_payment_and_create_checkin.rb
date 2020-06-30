# typed: false
class Checkins::UpdatePaymentAndCreateCheckin
  include Interactor::Organizer

  organize(
    Billing::Payment::UpdateUserPayment,
    Checkins::CreateCheckin
  )
end
