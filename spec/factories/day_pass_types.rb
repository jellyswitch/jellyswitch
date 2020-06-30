# typed: false
# == Schema Information
#
# Table name: day_pass_types
#
#  id                           :bigint(8)        not null, primary key
#  always_allow_building_access :boolean          default(FALSE), not null
#  amount_in_cents              :integer          default(0), not null
#  available                    :boolean          default(TRUE), not null
#  code                         :string
#  name                         :string           not null
#  visible                      :boolean          default(TRUE), not null
#  created_at                   :datetime         not null
#  updated_at                   :datetime         not null
#  operator_id                  :integer          not null
#

FactoryBot.define do
  factory :day_pass_type do
    sequence(:name) { |n| "Jellywork day pass #{n}" }
    amount_in_cents { rand(8_000) }
    operator
  end
end
