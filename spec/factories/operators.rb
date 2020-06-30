# typed: false
# == Schema Information
#
# Table name: operators
#
#  id                            :bigint(8)        not null, primary key
#  android_server_key            :string
#  android_url                   :string
#  announcements_enabled         :boolean          default(TRUE), not null
#  approval_required             :boolean          default(TRUE), not null
#  billing_state                 :string           default("demo"), not null
#  building_address              :string           default("not set"), not null
#  bulletin_board_enabled        :boolean          default(FALSE), not null
#  checkin_notifications         :boolean          default(TRUE), not null
#  checkin_required              :boolean          default(FALSE), not null
#  childcare_enabled             :boolean          default(FALSE), not null
#  contact_email                 :string
#  contact_name                  :string
#  contact_phone                 :string
#  credits_enabled               :boolean          default(FALSE), not null
#  day_pass_cost_in_cents        :integer          default(2500), not null
#  day_pass_notifications        :boolean          default(TRUE), not null
#  door_integration_enabled      :boolean          default(TRUE), not null
#  email_enabled                 :boolean          default(FALSE), not null
#  events_enabled                :boolean          default(TRUE), not null
#  ios_url                       :string
#  kisi_api_key                  :string
#  member_feedback_notifications :boolean          default(TRUE), not null
#  membership_notifications      :boolean          default(TRUE), not null
#  membership_text               :string
#  name                          :string           not null
#  offices_enabled               :boolean          default(TRUE), not null
#  post_notifications            :boolean          default(TRUE), not null
#  refund_notifications          :boolean          default(TRUE), not null
#  reservation_notifications     :boolean          default(FALSE), not null
#  rooms_enabled                 :boolean          default(TRUE), not null
#  signup_notifications          :boolean          default(FALSE), not null
#  skip_onboarding               :boolean          default(FALSE), not null
#  snippet                       :string           default("Generic snippet about the space"), not null
#  square_footage                :integer          default(0), not null
#  stripe_access_token           :string
#  stripe_publishable_key        :string
#  stripe_refresh_token          :string
#  subdomain                     :string           not null
#  wifi_name                     :string           default("not set"), not null
#  wifi_password                 :string           default("not set"), not null
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  stripe_user_id                :string
#
# Indexes
#
#  index_operators_on_subdomain  (subdomain) UNIQUE
#

FactoryBot.define do
  factory :operator do
    sequence(:name) { |n| "jellywork-#{n}" }
    approval_required { true }
    snippet { Faker::TvShows::GameOfThrones.quote }
    wifi_name { name }
    wifi_password { Faker::Ancient.god }
    building_address { Faker::Address.full_address }
    contact_name { Faker::Name.unique.name }
    contact_email { Faker::Internet.unique.safe_email }
    contact_phone { Faker::PhoneNumber.phone_number }
    square_footage { 2000 }
    skip_onboarding { true }
    sequence(:subdomain) { |n| "test-#{n}" }
    stripe_user_id { ENV['STRIPE_ACCOUNT_ID'] }

    trait :with_location do
      after(:create) do |operator|
        create(:location, operator: operator)
      end
    end

    trait :with_multiple_locations do
      after(:create) do |operator|
        create(:location, operator: operator)
        create(:location, operator: operator)
      end
    end

    trait :with_users do
      transient do
        user_count { 5 }

        after(:create) do |operator, evaluator|
          create_list(:user, evaluator.user_count, operator: operator)
        end
      end
    end

    trait :with_individual_plans do
      transient do
        plans_count { 3 }
      end

      after(:create) do |operator, evaluator|
        create_list(:plan, evaluator.plans_count, operator: operator, plan_type: 'individual')
      end
    end

    trait :with_lease_plans do
      transient do
        plans_count { 3 }
      end

      after(:create) do |operator, evaluator|
        create_list(:plan, evaluator.plans_count, operator: operator, plan_type: 'lease')
      end
    end

    trait :with_organizations do
      transient do
        org_count { 3 }

        after(:create) do |operator, evaluator|
          org_owner = create(:user, operator: operator)
          create_list(:organization, evaluator.org_count, operator: operator, owner: org_owner)
        end
      end
    end

    trait :with_offices do
      transient do
        office_count { 3 }
      end

      after(:create) do |operator, evaluator|
        create_list(:office, evaluator.office_count, operator: operator)
      end
    end

    trait :with_day_passes do
      transient do
        day_pass_type_count { 3 }
      end

      after(:create) do |operator, evaluator|
        create_list(:day_pass_type, evaluator.day_pass_type_count, operator: operator)
      end
    end

    factory :operator_with_plans_and_users, traits: [:with_individual_plans, :with_users]
    factory :operator_with_plans_orgs_and_offices,
            traits: [
              :with_individual_plans,
              :with_lease_plans,
              :with_organizations,
              :with_offices,
            ]
  end
end
