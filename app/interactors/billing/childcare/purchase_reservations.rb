class Billing::Childcare::PurchaseReservations
  include Interactor::Organizer

  organize(
    Billing::Childcare::CreateStripeInvoice,
    Billing::Childcare::CreditAccount
  )
end