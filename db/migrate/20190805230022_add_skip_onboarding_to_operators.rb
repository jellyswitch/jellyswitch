class AddSkipOnboardingToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :skip_onboarding, :boolean, default: false, null: false
  end
end
