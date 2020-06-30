# typed: true
class CreateOfficeLeases < ActiveRecord::Migration[5.2]
  def change
    create_table :office_leases do |t|
      t.references :operator, foreign_key: true, null: false
      t.references :organization, foreign_key: true, null: false
      t.references :office, foreign_key: true, null: false
      t.references :plan, foreign_key: true, null: false
      t.date :start_date, null: false
      t.date :end_date, null: false

      t.timestamps
    end
  end
end
