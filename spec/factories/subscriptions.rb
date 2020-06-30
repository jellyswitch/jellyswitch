# typed: false
# == Schema Information
#
# Table name: subscriptions
#
#  id                     :bigint(8)        not null, primary key
#  active                 :boolean          default(TRUE), not null
#  billable_type          :string
#  pending                :boolean          default(FALSE), not null
#  start_date             :date             not null
#  subscribable_type      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  billable_id            :bigint(8)
#  plan_id                :integer          not null
#  stripe_subscription_id :string
#  subscribable_id        :bigint(8)
#
# Indexes
#
#  index_subscriptions_on_billable_type_and_billable_id          (billable_type,billable_id)
#  index_subscriptions_on_subscribable_type_and_subscribable_id  (subscribable_type,subscribable_id)
#

FactoryBot.define do
  factory :subscription do
    plan

    trait :for_user do
      association :subscribable, factory: :user
      association :billable, factory: :user
    end

    trait :with_stripe_info do
      after(:create) do |subscription|
        operator = subscription.plan.operator

        subscription.stripe_subscription_id = operator.create_stripe_subscription(
          user,
          plan
        )
      end
    end
  end
end
