# typed: false
class AddCardAddedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :card_added, :boolean, default: false, null: false
  end
end
