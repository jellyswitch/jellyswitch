# typed: false
module Notifiable
  class DayPass < Notifiable::Default
    def create_feed_item
      blob = {type: "day-pass", day_pass_id: id}
      FeedItemCreator.create_feed_item(operator, user, blob)
    end

    def should_send_notification?
      operator.day_pass_notifications?
    end

    def message
      message = "#{user.name} has purchased a day pass"

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
