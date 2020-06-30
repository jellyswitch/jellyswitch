# typed: false
class ChangeOutOfBandDefaultOnOrganizations < ActiveRecord::Migration[5.2]
  def change
    change_column_default :organizations, :out_of_band, true
  end
end
