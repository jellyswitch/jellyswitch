# typed: false
# == Schema Information
#
# Table name: locations
#
#  id                                  :bigint(8)        not null, primary key
#  allow_hourly                        :boolean          default(FALSE), not null
#  billing_state                       :string
#  building_access_instructions        :string
#  building_address                    :string
#  childcare_reservation_cost_in_cents :integer          default(0), not null
#  city                                :string
#  common_square_footage               :integer          default(0), not null
#  contact_email                       :string
#  contact_name                        :string
#  contact_phone                       :string
#  credit_cost_in_cents                :integer          default(0), not null
#  flex_square_footage                 :integer          default(0), not null
#  hourly_rate_in_cents                :integer          default(0), not null
#  name                                :string
#  new_users_get_free_day_pass         :boolean          default(FALSE), not null
#  open_friday                         :boolean          default(TRUE), not null
#  open_monday                         :boolean          default(TRUE), not null
#  open_saturday                       :boolean          default(FALSE), not null
#  open_sunday                         :boolean          default(FALSE), not null
#  open_thursday                       :boolean          default(TRUE), not null
#  open_tuesday                        :boolean          default(TRUE), not null
#  open_wednesday                      :boolean          default(TRUE), not null
#  snippet                             :string
#  square_footage                      :integer
#  state                               :string
#  stripe_access_token                 :string
#  stripe_publishable_key              :string
#  stripe_refresh_token                :string
#  time_zone                           :string           default("Pacific Time (US & Canada)"), not null
#  visible                             :boolean          default(TRUE), not null
#  wifi_name                           :string
#  wifi_password                       :string
#  working_day_end                     :string           default("18:00"), not null
#  working_day_start                   :string           default("09:00"), not null
#  zip                                 :string
#  created_at                          :datetime         not null
#  updated_at                          :datetime         not null
#  operator_id                         :bigint(8)        not null
#  stripe_user_id                      :string
#
# Indexes
#
#  index_locations_on_operator_id     (operator_id)
#  index_locations_on_state_and_city  (state,city)
#  index_locations_on_zip             (zip)
#
# Foreign Keys
#
#  fk_rails_...  (operator_id => operators.id)
#

FactoryBot.define do
  factory :location do
    sequence(:name) { |n| "jellywork-#{n}" }
    snippet { Faker::TvShows::GameOfThrones.quote }
    wifi_name { name }
    wifi_password { Faker::Ancient.god }
    building_address { Faker::Address.full_address }
    contact_name { Faker::Name.unique.name }
    contact_email { Faker::Internet.unique.safe_email }
    contact_phone { Faker::PhoneNumber.phone_number }
    square_footage { 2000 }
    stripe_user_id { ENV['STRIPE_ACCOUNT_ID'] }
    operator

    trait :with_offices do
      transient do
        office_count { 3 }
      end

      after(:create) do |location, evaluator|
        create_list(:office, evaluator.office_count, location: location, operator: location.operator)
      end
    end
  end
end
