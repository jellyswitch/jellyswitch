# typed: true
class Billing::Invoices::Refunds::Create
  include Interactor::Organizer

  organize(
    Billing::Invoices::Refunds::Save # did this so that we could use CreateNotifications in the future
  )
end
