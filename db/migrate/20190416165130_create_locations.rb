# typed: false
class CreateLocations < ActiveRecord::Migration[5.2]
  def change
    create_table :locations do |t|
      t.string :name
      t.references :operator, foreign_key: true, null: false
      t.string :billing_state
      t.string :building_address
      t.string :city
      t.string :state
      t.string :zip
      t.string :contact_email
      t.string :contact_name
      t.string :contact_phone
      t.string :snippet
      t.integer :square_footage
      t.string :stripe_access_token
      t.string :stripe_publishable_key
      t.string :stripe_refresh_token
      t.string :wifi_name
      t.string :wifi_password
      t.boolean :working_hours_enabled, default: false, null: false
      t.string :working_day_start, default: "09:00", null: false
      t.string :working_day_end, default: "18:00", null: false
      t.string :stripe_user_id

      t.timestamps
    end

    add_index :locations, [:state, :city]
    add_index :locations, :zip
  end
end
