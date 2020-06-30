# typed: true
class CreateUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email, null: false, unique: true
      t.string :password_digest
      t.boolean :admin, default: false, null: false
      t.string :remember_digest
      t.string :slug, unique: true

      t.text :bio
      t.string :linkedin
      t.string :twitter
      t.string :website

      t.timestamps
    end
  end
end
