# typed: false
# == Schema Information
#
# Table name: users
#
#  id                            :bigint(8)        not null, primary key
#  admin                         :boolean          default(FALSE), not null
#  always_allow_building_access  :boolean          default(FALSE), not null
#  android_token                 :string
#  approved                      :boolean          default(FALSE), not null
#  archived                      :boolean          default(FALSE), not null
#  bill_to_organization          :boolean          default(FALSE), not null
#  bio                           :text
#  card_added                    :boolean          default(FALSE), not null
#  childcare_reservation_balance :integer          default(0), not null
#  credit_balance                :integer          default(0), not null
#  email                         :string           not null
#  ios_token                     :string
#  linkedin                      :string
#  name                          :string
#  out_of_band                   :boolean          default(FALSE), not null
#  password_digest               :string
#  phone                         :string
#  remember_digest               :string
#  reset_digest                  :string
#  reset_sent_at                 :datetime
#  slug                          :string
#  superadmin                    :boolean          default(FALSE), not null
#  twitter                       :string
#  website                       :string
#  created_at                    :datetime         not null
#  updated_at                    :datetime         not null
#  operator_id                   :integer          default(2), not null
#  organization_id               :integer
#  stripe_customer_id            :string
#
# Indexes
#
#  index_users_on_operator_id  (operator_id)
#

FactoryBot.define do
  factory :user, aliases: [:owner] do
    name { Faker::Name.unique.name }
    email { Faker::Internet.unique.safe_email }
    password { 'password' }
    bio { Faker::TvShows::GameOfThrones.quote }
    operator

    trait :admin do
      approved { true }
      admin { true }
    end

    trait :superadmin do
      approved { true }
      superadmin { true }
    end

    trait :with_stripe_info do
      after(:create) do |user|
        stripe_token = Stripe::Token.create({
          card: {
            number: '4242424242424242',
            exp_month: 3,
            exp_year: 2020,
            cvc: '314',
          },
        })

        user.stripe_customer_id = user.operator.create_stripe_customer(user).id
        user.save
        stripe_customer = user.stripe_customer
        stripe_customer.source = stripe_token.id
        stripe_customer.save
      end
    end

    trait :reindex do
    end
  end
end
