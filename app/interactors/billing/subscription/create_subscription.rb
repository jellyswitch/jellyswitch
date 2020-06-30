# typed: false
class Billing::Subscription::CreateSubscription
  include Interactor::Organizer

  organize(
    Billing::Subscription::SaveSubscription,
    Billing::Subscription::CreateStripeSubscription,
    CreateNotifications
  )
end
