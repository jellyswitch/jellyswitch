class FeedItems::Reservation < ApplicationComponent
  include ApplicationHelper
  
  def initialize(feed_item:)
    @feed_item = feed_item
  end

  private

  attr_reader :feed_item

  def credits_enabled?
    feed_item.operator.credits_enabled?
  end
end