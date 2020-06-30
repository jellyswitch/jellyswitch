class Rooms::DurationButton < ApplicationComponent
  include ApplicationHelper
  include CreditHelper

  def initialize(room:, day:, hour:, user:, duration: duration)
    @room = room
    @day = day
    @hour = hour
    @user = user
    @duration = duration
  end

  private

  attr_reader :room, :day, :hour, :user, :duration

  def positive_label
    "#{label} (costs #{number_to_human(reservation_cost(room, duration))} credits)"
  end

  def negative_label
    "#{label} (#{number_to_human(-balance)} more credits needed)"
  end

  def label
    if duration < 60
      delimiter = quantize(duration, "minute")
      "#{duration} #{delimiter}"
    else
      hours = (duration.to_f / 60.0)
      delimiter = quantize(hours, "hour")
      "#{number_to_human(hours)} #{delimiter}"
    end
  end

  def balance
    user.credit_balance - reservation_cost(room, duration)
  end

  def has_enough_credits?
    balance >= 0
  end

  def credits_enabled?
    room.operator.credits_enabled?
  end
end