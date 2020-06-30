class CreateChildcareSlots < ActiveRecord::Migration[6.0]
  def change
    create_table :childcare_slots do |t|
      t.string :name, null: false
      t.integer :week_day, null: false
      t.boolean :deleted, null: false, default: false
      t.integer :location_id, null: false

      t.timestamps
    end
  end
end
