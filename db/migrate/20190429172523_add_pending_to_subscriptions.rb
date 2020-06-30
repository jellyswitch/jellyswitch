# typed: false
class AddPendingToSubscriptions < ActiveRecord::Migration[5.2]
  def change
    add_column :subscriptions,  :pending, :boolean, null: false, default: false
  end
end
