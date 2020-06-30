# typed: false
class Operator::LandingController < Operator::BaseController
  before_action :background_image
  include LandingHelper
  include EventHelper

  def index
    landing_redirect
  end

  def home
    @doors = Door.all
    @member_feedback = MemberFeedback.new
    find_upcoming_events
    response.headers["Turbolinks-Location"] = home_url
    home_redirect
  end

  def wait
    if !logged_in?
      redirect_to root_path
    end

    if (current_user.allowed_in?(current_location) && approved?)
      redirect_to home_path
    end
  end

  def activate
    if current_user.out_of_band?
      result = Billing::Subscription::ActivatePendingSubscription.call(
        subscription: current_user.subscriptions.pending.first,
        user: current_user,
        operator: current_tenant,
        start_day: nil,
      )
      if result.success?
        # redirect to home
        flash[:success] = "Welcome!"
        turbolinks_redirect(home_path, action: "restore")
      else
        flash[:error] = result.message
        turbolinks_redirect(activate_path, action: "restore")
      end
    else
      include_stripe
    end
  end

  def activate_membership
    # update billing info
    token = params[:stripeToken]
    result = Billing::Payment::UpdateUserPayment.call(
      user: current_user,
      token: token,
      out_of_band: false,
    )
    if result.success?
      # activate membership
      result2 = Billing::Subscription::ActivatePendingSubscription.call(
        subscription: current_user.subscriptions.pending.first,
        user: current_user,
        operator: current_tenant,
        start_day: nil,
      )
      if result2.success?
        # redirect to home
        flash[:success] = "Welcome!"
        turbolinks_redirect(home_path, action: "restore")
      else
        flash[:error] = result2.message
        turbolinks_redirect(activate_path, action: "restore")
      end
    else
      flash[:error] = result.message
      turbolinks_redirect(activate_path, action: "restore")
    end
  end

  def choose
    if !logged_in?
      redirect_to root_path
    else
      if (!policy(:payment).enabled? && current_tenant.subdomain != "southlakecoworking") || (current_user.member?(current_location) && approved?) || admin?
        redirect_to home_path
      end
    end
    @day_pass_types = current_tenant.day_pass_types.available.visible
    @plans = current_tenant.plans.for_individuals.order("amount_in_cents DESC")
    @plan = current_tenant.plans.available.visible.individual.cheapest
    @rooms = current_location.rooms.visible.rentable
  end

  def upgrade
    @day_pass_types = current_tenant.day_pass_types.available.visible.order("amount_in_cents DESC")
    @plans = current_tenant.plans.for_individuals.order("amount_in_cents DESC")
  end

  # High level pages for nav
  def members_groups
    authorize :dashboard, :show?
    @report = Jellyswitch::Report.new(current_tenant)
  end

  def plans_day_passes
    authorize :dashboard, :show?
  end

  def customization
    authorize :dashboard, :show?
  end

  def announcements_events
    authorize :dashboard, :show?
  end

  def privacy_policy
  end
end
