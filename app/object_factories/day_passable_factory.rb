# typed: true
class DayPassableFactory
  def self.for(day_pass)
    if day_pass.billable.out_of_band?
      DayPassable::OutOfBand
    else
      DayPassable::InBand
    end.new(day_pass)
  end
end