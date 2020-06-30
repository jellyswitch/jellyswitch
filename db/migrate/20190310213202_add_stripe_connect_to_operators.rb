# typed: false
class AddStripeConnectToOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :operators, :stripe_user_id, :string
    add_column :operators, :stripe_publishable_key, :string
    add_column :operators, :stripe_refresh_token, :string
    add_column :operators, :stripe_access_token, :string
  end
end
