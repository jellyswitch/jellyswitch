class AddChildcareReservationsToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :childcare_reservations, :integer, null: false, default: 0
  end
end
