class AddChildcareReservationsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :childcare_reservation_balance, :integer, null: false, default: 0
  end
end
