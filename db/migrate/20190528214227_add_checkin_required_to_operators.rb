# typed: false
class AddCheckinRequiredToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :checkin_required, :boolean, default: false, null: false
  end
end
