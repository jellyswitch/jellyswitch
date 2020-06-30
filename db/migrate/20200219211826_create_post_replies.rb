class CreatePostReplies < ActiveRecord::Migration[6.0]
  def change
    create_table :post_replies do |t|
      t.integer :post_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
