class Operator::PostsController < Operator::BaseController
  include PostsHelper
  before_action :background_image

  def index
    find_posts
    authorize @posts
  end

  def new
    @post = current_location.posts.new
    authorize @post
  end

  def create
    result = Posts::Create.call(
      location: current_location,
      user: current_user,
      params: post_params
    )

    if result.success?
      turbolinks_redirect(post_path(result.post))
    else
      flash[:error] = result.message
      turbolinks_redirect(new_post_path, action: "replace")
    end
  end

  def show
    find_post
    authorize @post
  end
end