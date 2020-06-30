class AddSourceToLeads < ActiveRecord::Migration[6.0]
  def change
    add_column :leads, :source, :string
  end
end
