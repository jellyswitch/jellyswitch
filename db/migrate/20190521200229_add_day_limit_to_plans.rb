# typed: false
class AddDayLimitToPlans < ActiveRecord::Migration[5.2]
  def change
    add_column :plans, :has_day_limit, :boolean, default: false, null: false
    add_column :plans, :day_limit, :integer, null: false, default: 0
  end
end
