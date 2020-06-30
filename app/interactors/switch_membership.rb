# typed: true
class SwitchMembership
  include Interactor

  def call
    old_subscription = context.old_subscription
    new_subscription = context.new_subscription

    ActiveRecord::Base.transaction do
      old_subscription.active = false
      new_subscription.active = true

      new_subscription.subscribable = old_subscription.subscribable
      new_subscription.billable = old_subscription.billable
      new_subscription.start_date = old_subscription.start_date

      new_subscription.stripe_subscription_id = old_subscription.stripe_subscription_id

      new_subscription.save!
      old_subscription.save!

      Stripe::Subscription.update(
        new_subscription.stripe_subscription_id,
        {
          cancel_at_period_end: false,
          items: [
            {
              id: new_subscription.stripe_subscription.items.data[0].id,
              plan: new_subscription.plan.stripe_plan_id
            }
          ],
      },{
        api_key: new_subscription.plan.operator.stripe_secret_key,
        stripe_account: new_subscription.plan.operator.stripe_user_id
      })
    end
  end
end
