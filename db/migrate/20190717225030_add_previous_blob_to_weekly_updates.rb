class AddPreviousBlobToWeeklyUpdates < ActiveRecord::Migration[5.2]
  def change
    add_column :weekly_updates, :previous_blob, :jsonb
  end
end
