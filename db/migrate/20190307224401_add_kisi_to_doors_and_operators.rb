# typed: false
class AddKisiToDoorsAndOperators < ActiveRecord::Migration[5.2]
  def change
    add_column :doors, :kisi_id, :integer
    add_column :operators, :kisi_api_key, :string
  end
end
