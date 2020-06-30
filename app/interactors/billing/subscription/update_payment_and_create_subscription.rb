# typed: false
class Billing::Subscription::UpdatePaymentAndCreateSubscription
  include Interactor::Organizer

  organize(
    Billing::Payment::UpdateUserPayment,
    Billing::Subscription::SaveSubscription,
    Billing::Subscription::CreateStripeSubscription,
    CreateNotifications
  )
end
