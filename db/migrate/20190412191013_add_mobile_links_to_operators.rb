# typed: false
class AddMobileLinksToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :ios_url, :string
    add_column :operators, :android_url, :string
  end
end
