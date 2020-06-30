class AddCommitmentIntervalToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :commitment_interval, :integer
  end
end
