# typed: false
# == Schema Information
#
# Table name: organizations
#
#  id                 :bigint(8)        not null, primary key
#  name               :string           not null
#  out_of_band        :boolean          default(TRUE), not null
#  slug               :string
#  website            :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  operator_id        :integer          default(1), not null
#  owner_id           :integer
#  stripe_customer_id :string
#
# Indexes
#
#  index_organizations_on_operator_id  (operator_id)
#

FactoryBot.define do
  factory :organization do
    operator
    owner
    name { Faker::Company.name }
    website { "https://www.example.com" }
    stripe_customer_id { 'cus_12345' }
  end
end
