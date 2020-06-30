class Posts::Post < ApplicationComponent
  include ApplicationHelper

  def initialize(post:)
    @post = post
  end

  private

  attr_accessor :post

  def replies
    post.post_replies.order(:created_at)
  end
end