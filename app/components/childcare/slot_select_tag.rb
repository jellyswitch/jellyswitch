class Childcare::SlotSelectTag < ApplicationComponent
  include ActionView::Helpers::FormOptionsHelper
  
  def initialize(f:, slots:, date:)
    @f = f
    @slots = slots
    @date = date
  end

  private

  attr_accessor :f, :slots, :date

  def disabled_slots
    slots.select do |slot|
      slot.remaining_capacity_on_day(date) < 1
    end.map do |slot|
      slot.id
    end
  end

  def options_for_slots
    slots.map do |slot|
      [slot.name_with_capacity(date), slot.id ]
    end
  end
end