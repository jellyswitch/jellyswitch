# typed: false
module Notifiable
  class Checkin < Notifiable::Default
    def create_feed_item
      blob = {type: "checkin", checkin_id: id}
      FeedItemCreator.create_feed_item(operator, user, blob, created_at: created_at)
    end

    def should_send_notification?
      location.operator.checkin_notifications?
    end

    def message
      message = "#{user.name} has checked into #{location.name}."

      unless user.approved?
        message = "Approval required: #{message}"
      end
      message
    end

    def recipients
      operator.users.admins
    end
  end
end
