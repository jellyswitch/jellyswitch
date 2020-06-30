# typed: true
class CreateOperatorSurveys < ActiveRecord::Migration[5.2]
  def change
    create_table :operator_surveys do |t|
      t.integer :user_id
      t.integer :operator_id
      t.integer :square_footage
      t.integer :number_of_members
      t.string :space_name
      t.string :operator_name
      t.string :operator_email
      t.string :location

      t.timestamps
    end
  end
end
