class CreateChildcareReservations < ActiveRecord::Migration[6.0]
  def change
    create_table :childcare_reservations do |t|
      t.integer :childcare_slot_id, null: false
      t.integer :child_profile_id, null: false
      t.date :date, null: false
      t.boolean :cancelled, null: false, default: false

      t.timestamps
    end
  end
end
