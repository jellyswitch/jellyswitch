# typed: true
class CreateSubdomains < ActiveRecord::Migration[5.2]
  def change
    create_table :subdomains do |t|
      t.string :subdomain, null: false
      t.boolean :in_use, null: false, default: false

      t.timestamps
    end
  end
end
