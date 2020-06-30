# typed: true
class CreateMemberFeedbacks < ActiveRecord::Migration[5.2]
  def change
    create_table :member_feedbacks do |t|
      t.boolean :anonymous, default: false, null: false
      t.text :comment
      t.integer :rating
      t.integer :operator_id, null: false
      t.integer :user_id

      t.timestamps
    end
  end
end
