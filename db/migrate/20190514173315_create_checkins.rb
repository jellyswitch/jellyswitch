# typed: true
class CreateCheckins < ActiveRecord::Migration[5.2]
  def change
    create_table :checkins do |t|
      t.integer :location_id, null: false
      t.integer :user_id, null: false
      t.datetime :datetime_in, null: false
      t.datetime :datetime_out
      t.integer :invoice_id

      t.timestamps
    end
  end
end
