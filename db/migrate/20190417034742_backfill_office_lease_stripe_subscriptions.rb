# typed: true
class BackfillOfficeLeaseStripeSubscriptions < ActiveRecord::Migration[5.2]
  def up
    unsuccessful_leases = []
    query = OfficeLease.joins(:subscription).
      where(subscriptions: { stripe_subscription_id: nil }).
      includes(:operator, :subscription, :organization)

    query.each do |office_lease|
      operator = office_lease.operator
      subscription = office_lease.subscription
      organization = office_lease.organization

      Stripe::Customer.update(
        organization.stripe_customer_id, {
          email: organization.email
        }, {
          api_key: operator.stripe_secret_key,
          stripe_account: operator.stripe_user_id
        }
      )

      start_date = Time.zone.at(1.month.from_now.beginning_of_month + 2.hours).to_i

      stripe_subscription = operator.create_stripe_subscription(organization, subscription, start_date)

      if stripe_subscription
        subscription.update(stripe_subscription_id: stripe_subscription.id)
      else
        unsuccessful_leases << [office_lease.id, subscription.id]
      end
    end

    if unsuccessful_leases.present?
      puts "Failed to create subscriptions in stripe for office leases: \n"
    end
    unsuccessful_leases.each do |lease|
      puts "Office lease with ID #{lease.first} and subscription ID #{lease.last}"
    end
  end

  def down
    raise ActiveRecord::IrreversibleMigration
  end
end
