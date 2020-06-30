class Reservations::DayList < ApplicationComponent
  include ApplicationHelper

  def initialize(reservation_hash:)
    @reservation_hash = reservation_hash
  end

  attr_accessor :reservation_hash

  def duration(reservation)
    if reservation.minutes > 60
      "#{reservation.minutes / 60.0} hours"
    else
      "#{reservation.minutes} minutes"
    end
  end
end