# typed: false
class AddBillableToCheckinsAndDayPasses < ActiveRecord::Migration[5.2]
  def change
    add_reference :day_passes, :billable, polymorphic: true

    DayPass.all.each do |day_pass|
      day_pass.update(billable: BillableFactory.for(day_pass).billable) if day_pass.user.present?
    end

    add_reference :checkins, :billable, polymorphic: true

    Checkin.all.each do |checkin|
      checkin.update(billable: BillableFactory.for(checkin).billable)
    end
  end
end
