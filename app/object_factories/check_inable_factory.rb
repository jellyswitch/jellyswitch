# typed: true
class CheckInableFactory
  def self.for(checkin)
    if checkin.billable.out_of_band?
      DayPassable::OutOfBand
    else
      DayPassable::InBand
    end.new(checkin)
  end
end