# typed: false
class CreateOrganizations < ActiveRecord::Migration[5.2]
  def change
    create_table :organizations do |t|
      t.string :name, null: false
      t.integer :owner_id
      t.string :website
      t.string :slug, unique: true

      t.timestamps
    end
    add_column :users, :organization_id, :integer, null: true
  end
end
