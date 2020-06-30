# typed: false
class CreateOrganization
  include Interactor::Organizer

  organize SaveOrganization, Billing::Payment::CreateStripeCustomer
end
