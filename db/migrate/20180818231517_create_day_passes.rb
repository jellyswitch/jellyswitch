# typed: true
class CreateDayPasses < ActiveRecord::Migration[5.2]
  def change
    create_table :day_passes do |t|
      t.date :day, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
