class CreateChildProfiles < ActiveRecord::Migration[6.0]
  def change
    create_table :child_profiles do |t|
      t.string :name
      t.datetime :birthday
      t.integer :user_id

      t.timestamps
    end
  end
end
