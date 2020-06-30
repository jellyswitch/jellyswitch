module PostsHelper
  def find_posts
    @posts = current_tenant.posts.order("created_at DESC")
  end

  def find_post(key=:id)
    @post = current_tenant.posts.find(params[key])
  end

  def post_params
    params.require(:post).permit(:content, :title)
  end

  def post_reply_params
    params.require(:post_reply).permit(:content, :post_id)
  end
end