# typed: true
class Operator::FeedItemCommentsController < Operator::BaseController
  def create
    find_feed_item
    authorize @feed_item

    result = FeedItems::CreateComment.call(
      feed_item: @feed_item,
      params: feed_item_comment_params,
      user: current_user
    )

    if result.success?
      flash[:success] = "Comment posted."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(feed_item_path(@feed_item))
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  private

  def find_feed_item(key=:feed_item_id)
    @feed_item = FeedItem.find(params[key])
  end

  def feed_item_comment_params
    params.require(:feed_item_comment).permit(:comment)
  end
end