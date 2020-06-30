# typed: false
class AddPlanTypeToPlans < ActiveRecord::Migration[5.2]
  def change
    reversible do |dir|
      dir.up do
        add_column :plans, :plan_type, :string

        Plan.update_all(plan_type: 'individual')
      end

      dir.down do
        remove_column :plans, :plan_type, :string
      end
    end
  end
end
