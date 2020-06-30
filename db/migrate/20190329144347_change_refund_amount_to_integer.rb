# typed: false
class ChangeRefundAmountToInteger < ActiveRecord::Migration[5.2]
  def up
    remove_column :refunds, :amount
    add_column :refunds, :amount, :integer, default: 0, null: false
  end

  def down
    remove_column :refunds, :amount
    add_column :refunds, :amount, :string
  end
end
