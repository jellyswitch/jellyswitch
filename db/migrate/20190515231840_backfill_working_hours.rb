# typed: false
class BackfillWorkingHours < ActiveRecord::Migration[5.2]
  def change
    Location.where(working_hours_enabled: false).each do |location|
      location.update(working_day_start: "09:00", working_day_end: "17:00")
    end

    remove_column :locations, :working_hours_enabled
  end
end
