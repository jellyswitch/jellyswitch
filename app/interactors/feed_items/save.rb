class FeedItems::Save
  include Interactor

  delegate :blob, :operator, :user, :photos, :created_at, to: :context

  def call
    @feed_item = FeedItem.new
    @feed_item.blob = blob
    @feed_item.operator = operator
    @feed_item.user = user

    if created_at.present?
      @feed_item.created_at = created_at
      @feed_item.updated_at = created_at
    end

    if photos.present?
      @feed_item.photos.attach(photos)
    end

    if @feed_item.is_expense_feed?
      @feed_item.parse_amount
      @feed_item.set_expense
    end

    if !@feed_item.save
      context.fail!(message: "Unable to post management note.")
    end

    context.notifiable = @feed_item
    context.feed_item = @feed_item
  end
end
