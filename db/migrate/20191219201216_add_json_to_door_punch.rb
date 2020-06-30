class AddJsonToDoorPunch < ActiveRecord::Migration[5.2]
  def change
    add_column :door_punches, :json, :jsonb
  end
end
