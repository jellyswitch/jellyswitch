# typed: true
class CreateOffices < ActiveRecord::Migration[5.2]
  def change
    create_table :offices do |t|
      t.references :operator, foreign_key: true, null: false
      t.string :name
      t.string :slug
      t.integer :capacity, default: 1, null: false
      t.boolean :visible, default: true, null: false
      t.text :description

      t.timestamps
    end
  end
end
