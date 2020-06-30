# typed: true
class CreateRooms < ActiveRecord::Migration[5.2]
  def change
    create_table :rooms do |t|
      t.string :name, null: false, unique: true
      t.text :description
      t.boolean :whiteboard, null: false, default: false
      t.boolean :av, null: false, default: false
      t.integer :capacity, null: false, default: 1
      t.string :slug

      t.timestamps
    end
  end
end
