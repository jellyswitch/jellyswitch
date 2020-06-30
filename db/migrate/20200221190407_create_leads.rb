class CreateLeads < ActiveRecord::Migration[6.0]
  def change
    create_table :leads do |t|
      t.integer :user_id, null: false
      t.integer :ahoy_visit_id
      t.string :status
      t.integer :operator_id, null: false

      t.timestamps
    end
  end
end
