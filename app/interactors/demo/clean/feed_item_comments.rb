class Demo::Clean::FeedItemComments
  include Interactor

  delegate :operator, to: :context

  def call
    operator.feed_items.each do |feed_item|
      feed_item.feed_item_comments.destroy_all
    end
  end
end