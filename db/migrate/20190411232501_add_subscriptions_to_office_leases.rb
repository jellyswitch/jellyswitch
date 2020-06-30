# typed: false
class AddSubscriptionsToOfficeLeases < ActiveRecord::Migration[5.2]
  def change
    add_reference :office_leases, :subscription, foreign_key: true
    remove_reference :office_leases, :plan, foreign_key: true
  end
end
