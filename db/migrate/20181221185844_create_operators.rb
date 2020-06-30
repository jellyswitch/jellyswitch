# typed: true
class CreateOperators < ActiveRecord::Migration[5.2]
  def change
    create_table :operators do |t|
      t.string :name, null: false
      t.string :subdomain, null: false

      t.timestamps
    end
  end
end
