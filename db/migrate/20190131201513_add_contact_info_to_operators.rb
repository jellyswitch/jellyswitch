# typed: false
class AddContactInfoToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :contact_name, :string
    add_column :operators, :contact_email, :string
    add_column :operators, :contact_phone, :string
  end
end
