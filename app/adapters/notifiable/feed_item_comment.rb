module Notifiable
  class FeedItemComment < Notifiable::Default
    def create_feed_item
    end

    def should_send_notification?
      operator.post_notifications?
    end

    def message
      "#{user.name} replied to a recent management note"
    end

    def recipients
      operator.users.admins
    end
  end
end
