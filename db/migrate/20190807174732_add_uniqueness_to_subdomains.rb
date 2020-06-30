class AddUniquenessToSubdomains < ActiveRecord::Migration[5.2]
  def change
    add_index :operators, :subdomain, :unique => true
  end
end
