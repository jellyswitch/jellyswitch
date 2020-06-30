class Posts::PostLink < ApplicationComponent
  include ApplicationHelper

  def initialize(post:)
    @post = post
  end

  private

  attr_accessor :post

  def title
    if post.title.length > 65
      "#{post.title.slice(0, 65)}..."
    else
      post.title
    end
  end
end