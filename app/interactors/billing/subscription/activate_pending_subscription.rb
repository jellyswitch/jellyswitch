# typed: false
class Billing::Subscription::ActivatePendingSubscription
  include Interactor::Organizer

  organize(
    Billing::Subscription::ActivateSubscription,
    Billing::Subscription::CreateStripeSubscription,
    CreateNotifications
  )
end