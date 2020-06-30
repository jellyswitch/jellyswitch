# typed: false
# == Schema Information
#
# Table name: offices
#
#  id             :bigint(8)        not null, primary key
#  capacity       :integer          default(1), not null
#  description    :text
#  name           :string
#  slug           :string
#  square_footage :integer          default(0), not null
#  visible        :boolean          default(TRUE), not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  location_id    :bigint(8)
#  operator_id    :bigint(8)        not null
#
# Indexes
#
#  index_offices_on_location_id  (location_id)
#  index_offices_on_operator_id  (operator_id)
#
# Foreign Keys
#
#  fk_rails_...  (location_id => locations.id)
#  fk_rails_...  (operator_id => operators.id)
#

FactoryBot.define do
  factory :office do
    name { Faker::Movies::HarryPotter.location }
    capacity { rand(50) }
    description { Faker::Lorem.paragraph(2) }
    operator
    location
  end
end
