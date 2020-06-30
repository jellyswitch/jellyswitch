# typed: false
module Notifiable
  class WeeklyUpdate < Notifiable::Default
    private

    def create_feed_item
      blob = {type: "weekly-update", weekly_update_id: id}
      user = ::User.first # Dave???
      FeedItemCreator.create_feed_item(operator, user, blob, created_at: created_at)
    end

    def should_send_notification?
      true
    end

    def message
      "Your weekly update has been posted in the feed. Take a look!"
    end

    def recipients
      operator.users.admins
    end
  end
end
