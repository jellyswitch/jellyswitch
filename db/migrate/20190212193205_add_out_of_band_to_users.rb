# typed: false
class AddOutOfBandToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :out_of_band, :boolean, default: false, null: false
  end
end
