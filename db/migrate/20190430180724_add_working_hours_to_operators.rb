# typed: false
class AddWorkingHoursToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :working_hours_enabled, :boolean, null: false, default: false
    add_column :operators, :working_day_start, :string, null: false, default: "09:00"
    add_column :operators, :working_day_end, :string, null: false, default: "18:00"
  end
end
