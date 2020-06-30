module Notifiable
  class MemberFeedback < Notifiable::Default
    private

    def create_feed_item
      blob = {type: "feedback", member_feedback_id: id}
      FeedItemCreator.create_feed_item(operator, user, blob, created_at: created_at)
    end

    def should_send_notification?
      operator.member_feedback_notifications?
    end

    def message
      "New member feedback"
    end

    def recipients
      operator.users.admins
    end
  end
end
