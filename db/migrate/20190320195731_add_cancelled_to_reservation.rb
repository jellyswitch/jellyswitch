# typed: false
class AddCancelledToReservation < ActiveRecord::Migration[5.2]
  def change
    add_column :reservations, :cancelled, :boolean, null: false, default: false
  end
end
