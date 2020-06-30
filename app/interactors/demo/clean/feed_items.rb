class Demo::Clean::FeedItems
  include Interactor

  delegate :operator, to: :context

  def call
    operator.feed_items.destroy_all 
  end
end