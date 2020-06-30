# typed: false
class AddPaidByOrganizationToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :bill_to_organization, :boolean, null: false, default: false
  end
end
