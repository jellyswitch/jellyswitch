class AddNotificationSettingsToOperator < ActiveRecord::Migration[6.0]
  def change
    add_column :operators, :reservation_notifications, :boolean, null: false, default: false
    add_column :operators, :membership_notifications, :boolean, null: false, default: true
    add_column :operators, :signup_notifications, :boolean, null: false, default: false
    add_column :operators, :day_pass_notifications, :boolean, null: false, default: true
    add_column :operators, :member_feedback_notifications, :boolean, null: false, default: true
    add_column :operators, :checkin_notifications, :boolean, null: false, default: true
    add_column :operators, :refund_notifications, :boolean, null: false, default: true
    add_column :operators, :post_notifications, :boolean, null: false, default: true
  end
end
