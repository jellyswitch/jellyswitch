class CreateAnnouncements < ActiveRecord::Migration[5.2]
  def change
    create_table :announcements do |t|
      t.integer :user_id
      t.text :body
      t.integer :operator_id

      t.timestamps
    end
  end
end
