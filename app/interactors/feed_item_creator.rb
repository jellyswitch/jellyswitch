# typed: false
module FeedItemCreator
  # for pub/sub
  def self.create_feed_item(operator, user, blob, options = {})
    feed_item = FeedItem.new
    feed_item.operator = operator
    feed_item.user = user
    feed_item.blob = blob

    if options[:day].present?
      feed_item.created_at = options[:day]
      feed_item.updated_at = options[:day]
    end

    if options[:created_at].present?
      feed_item.created_at = options[:created_at]
      feed_item.updated_at = options[:created_at]
    end

    feed_item.save!
  end

  def create_feed_item(operator, user, blob, options = {})
    return if user.class == Organization # don't create a feed item if the billable was an organization

    feed_item = FeedItem.new
    feed_item.operator = operator
    feed_item.user = user
    feed_item.blob = blob

    if options[:day].present?
      feed_item.created_at = options[:day]
      feed_item.updated_at = options[:day]
    end

    if options[:created_at].present?
      feed_item.created_at = options[:created_at]
      feed_item.updated_at = options[:created_at]
    end

    if !feed_item.save
      context.fail!(message: "Unable to generate feed item.")
    end

    operator.users.admins.each do |admin_user|
      send_email_notification(admin_user, feed_item)
    end
    feed_item
  end

  def send_email_notification(user, feed_item)
    case feed_item.type
    when "feedback"
      FeedItemsMailer.member_feedback(user: user, feed_item: feed_item).deliver_later
    end
  end
end
