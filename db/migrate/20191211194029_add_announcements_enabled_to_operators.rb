class AddAnnouncementsEnabledToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :announcements_enabled, :boolean, null: false, default: true
  end
end
