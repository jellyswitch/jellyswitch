class Operator::WeeklyUpdatesController < Operator::BaseController
  before_action :background_image
  include ActionView::Helpers::NumberHelper
  
  def index
    find_weekly_updates
    authorize @weekly_updates
  end

  def show
    find_weekly_update
  end

  def create
    @week_start = Time.current.beginning_of_week
    @week_end = Time.current.end_of_week
    authorize WeeklyUpdate

    result = WeeklyUpdates::Create.call(operator: current_tenant, week_start: @week_start, week_end: @week_end)

    if result.success?
      turbolinks_redirect(weekly_update_path(result.weekly_update), action: "replace")
    else
      flash[:error] = result.message
      turbolinks_redirect(weekly_updates_path, action: "replace")
    end
  end

  private

  def find_weekly_updates
    @weekly_updates = current_tenant.weekly_updates.order('week_start DESC').all
  end

  def find_weekly_update(key=:id)
    @weekly_update = current_tenant.weekly_updates.find(params[key])
  end
end