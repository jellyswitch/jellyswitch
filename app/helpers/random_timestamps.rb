module RandomTimestamps
  def temp_day
    week = Array(0..3).sample
    if week == 0
      d = Time.current - Array(0..2).sample.days
    else
      d = Time.current - week.weeks + Array(1..4).sample.days
    end
    d
  end
end