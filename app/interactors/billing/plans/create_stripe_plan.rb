# typed: true
class Billing::Plans::CreateStripePlan
  include Interactor

  delegate :plan, :operator, to: :context

  def call
    stripe_plan = Stripe::Plan.create({
      amount: plan.amount_in_cents,
      interval: plan.stripe_interval,
      interval_count: plan.stripe_interval_count,
      product: { name: plan.plan_name },
      currency: 'usd',
      id: plan.plan_slug
    }, {
      api_key: operator.stripe_secret_key,
      stripe_account: operator.stripe_user_id
    })
    plan.stripe_plan_id = stripe_plan.id
    plan.save
  rescue StandardError => e
    context.fail!(message: e.message)
  end
end