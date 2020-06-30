# typed: false
class AddOperatorToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :operator_id, :integer, null: false, default: 2
    add_index :users, :operator_id
  end
end
