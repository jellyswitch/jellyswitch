class CreateLeadNotes < ActiveRecord::Migration[6.0]
  def change
    create_table :lead_notes do |t|
      t.integer :lead_id, null: false
      t.integer :user_id, null: false

      t.timestamps
    end
  end
end
