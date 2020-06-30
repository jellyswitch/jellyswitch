# typed: true
class CreateReservations < ActiveRecord::Migration[5.2]
  def change
    create_table :reservations do |t|
      t.integer :user_id, null: false
      t.datetime :datetime_in, null: false
      t.integer :hours, null: false, default: 1
      t.integer :room_id, null: false

      t.timestamps
    end
  end
end
