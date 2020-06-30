require 'icalendar/tzinfo'

class Time
  def beginning_of_half_hour
    if min >= 0 && min < 30
      change(min: 0)
    else
      change(min: 30)
    end
  end
end