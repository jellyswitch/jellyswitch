class CreateWeeklyUpdates < ActiveRecord::Migration[5.2]
  def change
    create_table :weekly_updates do |t|
      t.integer :operator_id
      t.jsonb :blob
      t.datetime :week_start
      t.datetime :week_end

      t.timestamps
    end
  end
end
