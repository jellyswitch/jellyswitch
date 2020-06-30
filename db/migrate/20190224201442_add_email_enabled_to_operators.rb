# typed: false
class AddEmailEnabledToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :email_enabled, :boolean, null: false, default: false
  end
end
