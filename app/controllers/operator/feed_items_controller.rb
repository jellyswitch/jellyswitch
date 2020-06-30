# typed: false
class Operator::FeedItemsController < Operator::BaseController
  include EventHelper
  include UsersHelper
  include FeedItemsHelper

  before_action :background_image
  before_action :find_todays_events
  before_action :find_room_reservations
  before_action :find_unapproved_users
  before_action :find_upcoming_renewals
  before_action :find_delinquent_invoices
  before_action :find_upcoming_childcare_reservations

  def index
    if !current_tenant.onboarded? && !current_tenant.skip_onboarding?
      turbolinks_redirect(new_operator_onboarding_path, action: "replace")
    else
      find_feed_items
      @all_active = "active"
      @questions_active = nil
      @activity_active = nil
      @notes_active = nil
      @financial_active = nil

      authorize @feed_items
    end
  end

  def questions
    find_questions
    @all_active = nil
    @questions_active = "active"
    @activity_active = nil
    @notes_active = nil
    @financial_active = nil
    authorize @feed_items
    render :index
  end

  def activity
    find_activity
    @all_active = nil
    @questions_active = nil
    @activity_active = "active"
    @notes_active = nil
    @financial_active = nil
    authorize @feed_items
    render :index
  end

  def notes
    find_notes
    @all_active = nil
    @questions_active = nil
    @activity_active = nil
    @notes_active = "active"
    @financial_active = nil
    authorize @feed_items
    render :index
  end

  def financial
    find_financial
    @all_active = nil
    @questions_active = nil
    @activity_active = nil
    @notes_active = nil
    @financial_active = "active"
    authorize @feed_items
    render :index
  end

  def show
    find_feed_item
    authorize @feed_item
  end

  def new
    new_feed_item
    authorize @feed_item
  end

  def create
    authorize FeedItem.new
    
    result = FeedItems::Create.call(
      blob: { text: feed_item_params[:text], type: "post" },
      user: current_user,
      operator: current_tenant,
      photos: feed_item_params[:photos],
    )

    if result.success?
      flash[:success] = "Posted!"
      turbolinks_redirect(feed_items_path, action: "restore")
    else
      flash[:error] = result.message
      turbolinks_redirect(feed_items_path, action: "restore")
    end
  rescue => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def destroy
    find_feed_item
    authorize @feed_item

    if @feed_item.destroy
      flash[:success] = "Deleted."
      turbolinks_redirect(feed_items_path, action: "restore")
    else
      flash[:error] = "Unable to delete that item."
      turbolinks_redirect(referrer_or_root)
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def set_expense_status
    find_feed_item
    turn_into_expense
    @comments = params[:comments] == "true"
    render :set_expense_status
  end

  def unset_expense_status
    find_feed_item
    not_an_expense
    @comments = params[:comments] == "true"
    render :set_expense_status
  end
end
