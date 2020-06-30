module Notifiable
  class PostReply < Notifiable::Default
    private

    def create_feed_item
      blob = {type: "bulletin-board-post-reply", post_reply_id: id}
      FeedItemCreator.create_feed_item(operator, user, blob, created_at: created_at)
    end

    def should_send_notification?
      true
    end

    def message
      "#{user.name} has replied to your post"
    end

    def recipients
      [post.user]
    end
  end
end
