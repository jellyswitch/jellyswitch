class AddCreditCostToRooms < ActiveRecord::Migration[6.0]
  def change
    add_column :rooms, :credit_cost, :integer, null: false, default: 0
  end
end
