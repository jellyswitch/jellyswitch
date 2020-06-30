class FeedItems::ChildcareReservation < ApplicationComponent
  include ApplicationHelper
  
  def initialize(feed_item:)
    @feed_item = feed_item
  end

  private

  attr_reader :feed_item

  def childcare_reservation
    feed_item.childcare_reservation
  end
end