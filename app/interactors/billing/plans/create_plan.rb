# typed: false
class Billing::Plans::CreatePlan
  include Interactor::Organizer

  organize(
    Billing::Plans::SavePlan,
    Billing::Plans::CreateStripePlan
  )
end