# typed: true
class CreateFeedItemComments < ActiveRecord::Migration[5.2]
  def change
    create_table :feed_item_comments do |t|
      t.integer :feed_item_id, null: false
      t.integer :user_id, null: false
      t.text :comment

      t.timestamps
    end
  end
end
