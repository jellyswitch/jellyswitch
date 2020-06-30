class AddAndroidServerKeyToOperators < ActiveRecord::Migration[6.0]
  def change
    add_column :operators, :android_server_key, :string
  end
end
