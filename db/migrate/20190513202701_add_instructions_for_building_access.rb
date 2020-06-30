# typed: false
class AddInstructionsForBuildingAccess < ActiveRecord::Migration[5.2]
  def change
    add_column :locations, :building_access_instructions, :string
  end
end
