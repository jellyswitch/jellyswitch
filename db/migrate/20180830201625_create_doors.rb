# typed: true
class CreateDoors < ActiveRecord::Migration[5.2]
  def change
    create_table :doors do |t|
      t.string :name, null: false
      t.string :slug, null: false
      t.boolean :available, null: false, default: true

      t.timestamps
    end
  end
end
