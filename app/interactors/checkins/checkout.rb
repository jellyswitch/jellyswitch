# typed: false
class Checkins::Checkout
  include Interactor::Organizer

  organize(
    SaveCheckout,
    CreateStripeInvoice
  )
end