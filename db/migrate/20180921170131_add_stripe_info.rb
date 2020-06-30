# typed: false
class AddStripeInfo < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :stripe_customer_id, :string
    add_column :subscriptions, :stripe_subscription_id, :string
    add_column :day_passes, :stripe_charge_id, :string
    add_column :plans, :stripe_plan_id, :string
  end
end
