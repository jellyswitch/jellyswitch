# typed: false
module Notifiable
  class Announcement < Notifiable::Default
    private

    def create_feed_item
      blob = {type: "announcement", announcement_id: id}
      FeedItemCreator.create_feed_item(operator, user, blob, created_at: created_at)
    end

    def should_send_notification?
      true
    end

    def message
      "New announcement from #{operator.name}: #{body}"
    end

    def recipients
      # all members
      operator.users.all.select do |user|
        user.admin? || user.superadmin? || user.member_at_operator?(@operator)
      end
    end
  end
end
