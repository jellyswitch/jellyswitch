# typed: true
# == Schema Information
#
# Table name: feed_item_comments
#
#  id           :bigint(8)        not null, primary key
#  comment      :text
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  feed_item_id :integer          not null
#  user_id      :integer          not null
#

class FeedItemComment < ApplicationRecord
  belongs_to :feed_item
  belongs_to :user
  validates :comment, presence: true

  after_commit :reindex_feed_item

  delegate :operator, to: :feed_item

  def reindex_feed_item
    feed_item.reindex
  end
end
