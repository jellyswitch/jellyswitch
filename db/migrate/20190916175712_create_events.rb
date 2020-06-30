class CreateEvents < ActiveRecord::Migration[5.2]
  def change
    create_table :events do |t|
      t.string :title, null: false
      t.text :description
      t.integer :user_id, null: false
      t.integer :location_id, null: false
      t.datetime :starts_at, null: false
      t.string :location_string
      t.datetime :ends_at

      t.timestamps
    end
  end
end
