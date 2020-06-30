class Demo::Clean::Invoices
  include Interactor::Organizer

  organize(
    Demo::Clean::OfficeLeases,
    Demo::Clean::Checkins,
    Demo::Clean::Memberships,
    Demo::Clean::DayPasses,
    Demo::Clean::Refunds,
    Demo::Clean::DeleteInvoices
  )
end