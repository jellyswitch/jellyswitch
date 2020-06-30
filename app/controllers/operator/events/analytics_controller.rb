class Operator::Events::AnalyticsController < Operator::BaseController
  before_action :background_image
  before_action :find_event

  def index
  end

  private

  def find_event
    @event = current_tenant.events.find(params[:event_id])
  end
end