# typed: false
class AddSquareFootageToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :square_footage, :integer, default: 0, null: false
  end
end
