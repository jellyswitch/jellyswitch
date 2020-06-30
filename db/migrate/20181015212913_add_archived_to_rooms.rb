# typed: false
class AddArchivedToRooms < ActiveRecord::Migration[5.2]
  def change
    add_column :rooms, :visible, :boolean, default: true, null: false
  end
end
