class AddCapacityToChildcareSlots < ActiveRecord::Migration[6.0]
  def change
    add_column :childcare_slots, :capacity, :integer, null: false, default: 0
  end
end
