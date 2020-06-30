# typed: true
class CreateDoorPunches < ActiveRecord::Migration[5.2]
  def change
    create_table :door_punches do |t|
      t.integer :door_id
      t.integer :user_id

      t.timestamps
    end
  end
end
