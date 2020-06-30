class AddEventsEnabledToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :events_enabled, :boolean, null: false, default: true
  end
end
