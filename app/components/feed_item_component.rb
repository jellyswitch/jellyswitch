class FeedItemComponent < ApplicationComponent
  include LayoutHelper

  def initialize(feed_item:, comments:)
    @feed_item = feed_item
    @comments = comments
  end

  private

  attr_reader :feed_item, :comments

  def show_feed_item?
    case feed_item.type
    when "announcement"
      true
    when "reservation"
      feed_item.operator.reservation_notifications?
    when "new-user"
      feed_item.operator.signup_notifications?
    when "checkin"
      feed_item.operator.checkin_notifications?
    when "childcare-reservation"
      true
    when "day-pass"
      feed_item.operator.day_pass_notifications?
    when "feedback"
      feed_item.operator.member_feedback_notifications?
    when "subscription"
      feed_item.operator.membership_notifications?
    when "refund"
      feed_item.operator.refund_notifications?
    when "post"
      feed_item.operator.post_notifications?
    when "weekly-update"
      true
    else
      false
    end
  end

  def subcomponent
    case feed_item.type
    when "announcement"
      FeedItems::Announcement
    when "checkin"
      FeedItems::Checkin
    when "childcare-reservation"
      FeedItems::ChildcareReservation
    when "reservation"
      FeedItems::Reservation
    else
      "operator/feed_items/#{feed_item.type.underscore}_feed_item"
    end
  end
end