# == Schema Information
#
# Table name: childcare_slots
#
#  id          :bigint(8)        not null, primary key
#  capacity    :integer          default(0), not null
#  deleted     :boolean          default(FALSE), not null
#  name        :string           not null
#  week_day    :integer          not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  location_id :integer          not null
#

FactoryBot.define do
  factory :childcare_slot do
    name { "MyString" }
    week_day { 1 }
    deleted { false }
    location_id { 1 }
  end
end
