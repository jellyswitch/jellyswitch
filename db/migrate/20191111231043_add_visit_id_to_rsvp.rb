class AddVisitIdToRsvp < ActiveRecord::Migration[5.2]
  def change
    add_column :rsvps, :ahoy_visit_id, :bigint
  end
end
