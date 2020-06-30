# == Schema Information
#
# Table name: childcare_reservations
#
#  id                :bigint(8)        not null, primary key
#  cancelled         :boolean          default(FALSE), not null
#  date              :date             not null
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  child_profile_id  :integer          not null
#  childcare_slot_id :integer          not null
#

FactoryBot.define do
  factory :childcare_reservation do
    childcare_slot_id { 1 }
    child_profile_id { 1 }
    date { "2020-01-28" }
  end
end
