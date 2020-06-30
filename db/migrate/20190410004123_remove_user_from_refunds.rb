# typed: false
class RemoveUserFromRefunds < ActiveRecord::Migration[5.2]
  def change
    remove_reference :refunds, :user, index: true, foreign_key: true
  end
end
