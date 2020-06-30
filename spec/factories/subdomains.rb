# typed: false
# == Schema Information
#
# Table name: subdomains
#
#  id         :bigint(8)        not null, primary key
#  in_use     :boolean          default(FALSE), not null
#  subdomain  :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryBot.define do
  factory :subdomain do
    sequence(:subdomain) { |n| "test-#{n}" }
    in_use { true }
  end
end
