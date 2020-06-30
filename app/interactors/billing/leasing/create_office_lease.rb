# typed: false
class Billing::Leasing::CreateOfficeLease
  include Interactor::Organizer

  organize(
    Billing::Plans::CreatePlan,
    Billing::Leasing::SaveOfficeLease,
    Billing::Leasing::CreateStripeSubscription
    )
end
