# typed: false
class CreateOperatorFeedItems < ActiveRecord::Migration[5.2]
  def change
    create_table :feed_items do |t|
      t.integer :operator_id, null: false
      t.integer :user_id
      t.jsonb :blob, null: false, default: '{}'

      t.timestamps
    end
    add_index :feed_items, :blob, using: :gin
  end
end
