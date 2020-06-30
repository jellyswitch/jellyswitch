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

class ChildcareReservation < ApplicationRecord
  belongs_to :childcare_slot
  belongs_to :child_profile

  default_scope { where(cancelled: false) }
  scope :upcoming, -> { where("date >= ?", Time.zone.now) }
  scope :for_date, -> (date) { where(date: date) }
  scope :for_slot, -> (childcare_slot) {where(childcare_slot_id: childcare_slot.id)}
  scope :for_profile, -> (child_profile) { where(child_profile_id: child_profile.id) }

  delegate :operator, to: :childcare_slot
  delegate :user, to: :child_profile
end
