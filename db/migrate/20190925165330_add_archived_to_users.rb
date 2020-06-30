class AddArchivedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :archived, :boolean, null: false, default: false
  end
end
