# == Schema Information
#
# Table name: post_replies
#
#  id         :bigint(8)        not null, primary key
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  post_id    :integer          not null
#  user_id    :integer          not null
#

class PostReply < ApplicationRecord
  belongs_to :post
  belongs_to :user

  delegate :operator, to: :post

  has_rich_text :content
end
