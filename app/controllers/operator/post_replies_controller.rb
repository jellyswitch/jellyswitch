class Operator::PostRepliesController < Operator::BaseController
  include PostsHelper
  before_action :background_image

  def create
    result = Posts::CreateReply.call(
      user: current_user,
      params: post_reply_params
    )

    if result.success?
      turbolinks_redirect(post_path(result.post_reply.post))
    else
      flash[:error] = result.message
      turbolinks_redirect(post_path(result.post_reply.post), action: "replace")
    end
  end
end