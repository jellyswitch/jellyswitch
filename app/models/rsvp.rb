# == Schema Information
#
# Table name: rsvps
#
#  id            :bigint(8)        not null, primary key
#  going         :boolean          default(TRUE), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  ahoy_visit_id :bigint(8)
#  event_id      :integer          not null
#  user_id       :integer          not null
#

class Rsvp < ApplicationRecord
  visitable :ahoy_visit

  belongs_to :event
  belongs_to :user

  scope :for_user, -> (user) { where(user_id: user.id) }
  scope :for_event, -> (event) { where(event_id: event.id) }
  scope :today, -> () do
    day_start = Time.current.beginning_of_day
    day_end = day_start.end_of_day
    joins(:event).where("events.starts_at > ? AND events.starts_at < ?", day_start, day_end)
  end
  scope :going, -> () { where(going: true) }
  scope :not_going, -> () { where(going: false) }

  def going?
    going == true
  end

  def not_going?
    going == false
  end
end
