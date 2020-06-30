module Notifiable
  class Reservation < Notifiable::Default
    private

    def create_feed_item
      blob = {type: "reservation", reservation_id: id}
      FeedItemCreator.create_feed_item(operator, user, blob)
    end

    def should_send_notification?
      operator.reservation_notifications?
    end

    def message
      "#{user.name} has reserved #{room.name}"
    end

    def recipients
      operator.users.admins
    end
  end
end
