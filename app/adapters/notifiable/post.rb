module Notifiable
  class Post < Notifiable::Default
    private

    def create_feed_item
      blob = {type: "bulletin-board-post", post_id: id}
      FeedItemCreator.create_feed_item(operator, user, blob, created_at: created_at)
    end

    def should_send_notification?
      true
    end

    def message
      "New bulletin board post from #{user.name}: #{title}"
    end
    
    def recipients
      # all members
      operator.users.all.select do |user|
        user.admin? || user.superadmin? || user.member_at_operator?(@operator)
      end
    end
  end
end
