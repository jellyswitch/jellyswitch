
class FeedItemsMailerPreview < ActionMailer::Preview
  def member_feedback
    FeedItemsMailer.member_feedback({feed_item: FeedItem.member_feedbacks.last, user: User.first})
  end
end