class Posts::SaveReply
  include Interactor

  delegate :user, :params, to: :context

  def call
    post_reply = PostReply.new(params)
    post_reply.user = user

    context.post_reply = post_reply

    if !post_reply.save
      context.fail!(message: "Could not save post reply.")
    end

    context.notifiable = post_reply
  end
end
