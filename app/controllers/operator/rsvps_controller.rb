class Operator::RsvpsController < Operator::BaseController
  before_action :background_image
  before_action :find_event

  def going
    result = ::Events::Going.call(
      event: @event,
      user: current_user
    )

    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(event_path(@event), action: "replace")
  end

  def not_going
    result = ::Events::NotGoing.call(
      event: @event,
      user: current_user
    )

    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(event_path(@event), action: "replace")
  end

  def register
    result = ::Events::RegisterAndGoing.call(
      event: @event,
      email: params[:email],
      visit: current_visit,
      operator: current_tenant
    )

    if result.success?
      log_in(result.user)
      set_location(@event.location)
      turbolinks_redirect(event_path(@event), action: "replace")
    else
      flash[:error] = result.message
    end
  end

  def login
    result = ::Events::LoginAndGoing.call(
      email: params[:session][:email],
      password: params[:session][:password],
      operator: current_tenant,
      event: @event
    )

    if result.success?
      log_in(result.user)
      set_location(@event.location)
      turbolinks_redirect(event_path(@event), action: "replace")
    else
      flash[:error] = result.message
    end
  end

  private

  def find_event
    @event = current_tenant.events.find(params[:event_id])
  end
end