# typed: false
module Notifiable
  class ChildcareReservation < Notifiable::Default
    def create_feed_item
      blob = {type: "childcare-reservation", childcare_reservation_id: id}
      FeedItemCreator.create_feed_item(operator, child_profile.user, blob, created_at: created_at)
    end

    def should_send_notification?
      true
    end

    def message
      "New childcare reservation for #{child_profile.name}"
    end

    def recipients
      operator.users.admins
    end
  end
end
