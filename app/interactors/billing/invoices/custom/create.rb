class Billing::Invoices::Custom::Create
  include Interactor::Organizer

  organize(
    Billing::Invoices::Custom::CreateInvoice
  )
end