class FeedItems::Announcement < ApplicationComponent
  include ApplicationHelper
  
  def initialize(feed_item:)
    @feed_item = feed_item
  end

  private

  attr_reader :feed_item
end