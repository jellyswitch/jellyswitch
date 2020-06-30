# typed: false
class AddDayPassTypeToDayPasses < ActiveRecord::Migration[5.2]
  def change
    add_column :day_passes, :day_pass_type_id, :integer
  end
end
