module Notifiable
  class User < Notifiable::Default
    private

    def create_feed_item
      blob = { type: "new-user" }
      FeedItemCreator.create_feed_item(operator, self.__getobj__, blob)
    end

    def should_send_notification?
      operator.signup_notifications?
    end

    def message
      "New user signup: #{name}"
    end

    def recipients
      operator.users.admins
    end
  end
end
