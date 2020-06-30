# typed: true
class Operator::SearchResultsController < Operator::BaseController
  before_action :background_image

  def new

  end

  def create
    @query = params[:query]
    turbolinks_redirect(query_search_results_path(query: @query), action: "advance")
  end

  def query
    @query = params[:query]
    @results = Searchkick.search(
      @query, 
      fields: [
        :name, 
        :text, 
        :comments, 
        :user_name, 
        :type, 
        :amount, 
        :stripe_customer_id, 
        :email, 
        :organization, 
        :owner,
        :announcement], 
      models: [FeedItem, User, Organization, Room, Door, Location, Announcement],
      operator: "or"
    )
    @results = @results.select {|r| r.operator == current_tenant}
    render :create, status: 200
  end
end