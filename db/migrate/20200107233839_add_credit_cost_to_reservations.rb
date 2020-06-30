class AddCreditCostToReservations < ActiveRecord::Migration[6.0]
  def change
    add_column :reservations, :credit_cost, :integer, null: false, default: 0
  end
end
