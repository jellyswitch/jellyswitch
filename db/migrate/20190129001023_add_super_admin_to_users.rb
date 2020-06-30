# typed: false
class AddSuperAdminToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :superadmin, :boolean, null: false, default: false
  end
end
