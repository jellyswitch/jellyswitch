# typed: false
class AddSquareFootageForMonetization < ActiveRecord::Migration[5.2]
  def change
    add_column :offices, :square_footage, :integer, null: false, default: 0
    add_column :rooms, :square_footage, :integer, null: false, default: 0
    add_column :locations, :flex_square_footage, :integer, null: false, default: 0
    add_column :locations, :common_square_footage, :integer, null: false, default: 0
  end
end
