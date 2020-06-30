# typed: false
# == Schema Information
#
# Table name: reservations
#
#  id          :bigint(8)        not null, primary key
#  cancelled   :boolean          default(FALSE), not null
#  credit_cost :integer          default(0), not null
#  datetime_in :datetime         not null
#  hours       :integer          default(1), not null
#  minutes     :integer          default(0), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :integer          not null
#  user_id     :integer          not null
#

class Reservation < ApplicationRecord
  # Relationships
  belongs_to :room
  belongs_to :user

  validates_with ReservationValidator

  default_scope { where(cancelled: false) }
  scope :not_cancelled, ->() { where(cancelled: false) }
  scope :this_month, -> () { where("datetime_in > ?", Time.current.beginning_of_month) }
  scope :for_room, -> (room) { where(room_id: room.id) }
  scope :for_week, -> (week_start, week_end) { where('datetime_in > ? and datetime_in <= ?', week_start, week_end) }
  scope :for_day, -> (day) { where(datetime_in: day.beginning_of_day..day.end_of_day) }
  scope :today, -> () { where(datetime_in: Time.current.beginning_of_day..Time.current.end_of_day) }
  scope :future, -> () { where("datetime_in >= ?", Time.current) }
  scope :past, -> () { where("datetime_in < ?", Time.current) }

  delegate :operator, to: :room
  
  def pretty_datetime
    datetime_in.strftime("%m/%d/%Y at %l:%M%P")
  end

  def self.for_time(time)
    select do |reservation|
      (reservation.datetime_in <= time) && (reservation.datetime_in + reservation.minutes.minutes > time)
    end.first
  end

  def self.for_time_inclusive(time)
    select do |reservation|
      (reservation.datetime_in <= time) && (reservation.datetime_in + reservation.minutes.minutes >= time)
    end.first
  end

  def room
    Room.unscoped { super }
  end

  def hours
    minutes.to_f / 60.0
  end

  def charge_amount
    ((room.hourly_rate_in_cents / 60.0) * minutes).to_i
  end

  def charge_description
    "#{room.location.operator.name} room reservation for #{pretty_datetime}"
  end
end
