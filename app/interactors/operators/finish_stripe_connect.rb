# typed: true
class Operators::FinishStripeConnect
  include Interactor

  def call
    stripe_code = context.stripe_code
    operator = context.operator
    webhook_url = context.webhook_url

    # Store credentials
    response = HTTParty.post("https://connect.stripe.com/oauth/token", 
      query: {
        client_secret: ENV['STRIPE_SECRET_KEY'],
        code: stripe_code,
        grant_type: "authorization_code"
    })
    
    if response["error"].present?
      context.fail!(message: response["error_description"])
    else
      stripe_user_id = response["stripe_user_id"]
      stripe_publishable_key = response["stripe_publishable_key"]
      refresh_token = response["refresh_token"]
      access_token = response["access_token"]

      result = operator.update(
        stripe_user_id: stripe_user_id,
        stripe_publishable_key: stripe_publishable_key,
        stripe_refresh_token: refresh_token,
        stripe_access_token: access_token,
        billing_state: "production"
      )

      if !result
        context.fail!(message: "There was a problem storing your Stripe credentials.")
      end

      # Overwrite existing user's stripe credentials with new stripe customer in new Stripe Connect account
      results = []
      operator.users.non_superadmins.each do |user|
        result = CreateStripeCustomer.call(user: user)
        results.push(result)
      end
      failures = results.select { |result| !result.success? }
      if failures.count > 0
        context.fail!(message: "Failed to create stripe customers for all users: #{failures.first.message}")
      end

      # Migrate plans
      operator.plans.each do |plan|
        plan.create_stripe_plan
      end
    end
  end
end