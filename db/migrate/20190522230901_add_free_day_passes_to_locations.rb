# typed: false
class AddFreeDayPassesToLocations < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :new_users_get_free_day_pass, :boolean, null: false, default: false
  end
end
