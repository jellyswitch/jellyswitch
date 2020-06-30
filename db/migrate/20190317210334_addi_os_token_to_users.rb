# typed: false
class AddiOsTokenToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :ios_token, :string
  end
end
