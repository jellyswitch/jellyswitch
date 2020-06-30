class AddChildcareReservationCostToLocations < ActiveRecord::Migration[6.0]
  def change
    add_column :locations, :childcare_reservation_cost_in_cents, :integer, null: false, default: 0
  end
end
