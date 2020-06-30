class CreatePosts < ActiveRecord::Migration[6.0]
  def change
    create_table :posts do |t|
      t.integer :location_id, null: false
      t.integer :user_id, null: false
      t.string :title, null: false

      t.timestamps
    end
  end
end
