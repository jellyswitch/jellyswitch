# typed: false
class Billing::Leasing::TerminateOfficeLease
  include Interactor::Organizer

  organize(
    Billing::Leasing::UpdateEndDate,
    CancelSubscription
  )
end