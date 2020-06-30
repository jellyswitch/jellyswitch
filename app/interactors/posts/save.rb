class Posts::Save
  include Interactor

  delegate :location, :user, :params, to: :context

  def call
    post = location.posts.new(params)
    post.user = user

    if !post.save
      context.fail!(message: "Error saving post.")
    end

    context.notifiable = post
    context.post = post
  end
end