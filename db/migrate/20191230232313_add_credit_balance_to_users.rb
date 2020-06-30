class AddCreditBalanceToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :credit_balance, :integer, null: false, default: 0
    add_column :plans, :credits, :integer, null: false, default: 0
  end
end
