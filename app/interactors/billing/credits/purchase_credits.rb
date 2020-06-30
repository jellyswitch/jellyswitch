class Billing::Credits::PurchaseCredits
  include Interactor::Organizer

  organize(
    Billing::Credits::CreateStripeInvoice,
    Billing::Credits::CreditAccount
  )
end