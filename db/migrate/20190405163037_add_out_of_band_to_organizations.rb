# typed: false
class AddOutOfBandToOrganizations < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :out_of_band, :boolean, default: false, null: false
  end
end
