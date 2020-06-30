class AddBulletinBoardEnabledToOperators < ActiveRecord::Migration[6.0]
  def change
    add_column :operators, :bulletin_board_enabled, :boolean, null: false, default: false
  end
end
