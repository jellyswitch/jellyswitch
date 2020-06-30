# typed: false
class DropWorkingHoursFromOperators < ActiveRecord::Migration[5.2]
  def change
    remove_column :operators, :working_hours_enabled
    remove_column :operators, :working_day_start
    remove_column :operators, :working_day_end
  end
end
