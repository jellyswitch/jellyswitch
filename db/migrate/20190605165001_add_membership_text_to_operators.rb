# typed: false
class AddMembershipTextToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :membership_text, :string
  end
end
