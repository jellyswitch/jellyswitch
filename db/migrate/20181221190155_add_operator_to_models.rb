# typed: false
class AddOperatorToModels < ActiveRecord::Migration[5.2]
  def up
    op = Operator.create!(name: "Cowork Tahoe", subdomain: "tml")

    tables = [:day_passes, :door_punches, :doors, :organizations, :plans, :rooms]
    tables.each do |table|
      add_column table, :operator_id, :integer, null: false, default: op.id
      add_index table, :operator_id
    end
  end

  def down
    tables = [:day_passes, :door_punches, :doors, :organizations, :plans, :rooms]
    tables.each do |table|
      remove_column table, :operator_id
    end
    Operator.destroy_all
  end
end
