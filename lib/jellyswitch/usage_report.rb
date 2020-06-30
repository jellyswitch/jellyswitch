# typed: true
class Jellyswitch::UsageReport
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def reservations
    @reservations ||= user.reservations.this_month.group_by_day(:datetime_in).count.reject do |k,v|
      v < 1
    end
  end

  def door_punches
    @door_punches ||= user.door_punches.this_month.group_by_day(:created_at).count.reject do |k,v|
      v < 1
    end
  end

  def checkins
    @checkins ||= user.checkins.this_month.group_by_day(:datetime_in).count.reject do |k,v|
      v < 1
    end
  end

  def day_passes
    @day_passes ||= user.day_passes.this_month.group_by_day(:day).count.reject do |k,v|
      v < 1
    end
  end

  def days_used
    @days_used ||= reservations.merge(door_punches) do |_,o,n|
      o+n
    end.merge(checkins) do |_,o,n|
      o+n
    end
  end

  def days_used_count
    days_used.count
  end

  def data_for_heatmap
    Hash[ days_used.map { |k, v| [k.to_time.to_i.to_s, v] } ]
  end
end