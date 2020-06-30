class Childcare::CalendarDay < ApplicationComponent
  def initialize(date:, location:)
    @date = date
    @location = location
    @slots = location.childcare_slots.visible.where(week_day: date.wday).order(:week_day, :name)
  end

  private

  attr_accessor :date, :location, :slots

  def spots_available
    @available_capacity ||= slots.sum do |slot|
      slot.remaining_capacity_on_day(date)
    end
  end

  def spots_available_class
    if spots_available < 1
      "text-danger"
    else
      "text-success"
    end
  end

  def link_class
    if spots_available < 1
      "disabled"
    else
      ""
    end
  end

  def past?
    date < Time.current
  end
end