class AddAndroidTokenToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :android_token, :string
  end
end
