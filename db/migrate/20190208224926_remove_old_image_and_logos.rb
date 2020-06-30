# typed: false
class RemoveOldImageAndLogos < ActiveRecord::Migration[5.2]
  def change
    remove_column :operators, :logo
    remove_column :operators, :background
  end
end
