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

class ChildcareSlot < ApplicationRecord
  belongs_to :location
  has_many :childcare_reservations

  scope :visible, -> { where(deleted: false) }

  delegate :operator, to: :location

  def visible?
    deleted == false
  end

  def weekday_name
    Date::DAYNAMES[week_day]
  end

  def pretty_name
    "#{weekday_name} #{name}"
  end

  def name_with_capacity(day)
    "#{pretty_name} (#{remaining_capacity_on_day(day)} spots left)"
  end

  def remaining_capacity_on_day(day)
    capacity - childcare_reservations.for_date(day).count
  end
end
