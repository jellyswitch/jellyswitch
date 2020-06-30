# typed: false
class AddCodeToDayPassTypes < ActiveRecord::Migration[5.2]
  def change
    add_column :day_pass_types, :code, :string
  end
end
