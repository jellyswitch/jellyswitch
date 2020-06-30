# typed: false
class Operator::EventsController < Operator::BaseController
  include EventHelper
  before_action :background_image

  def index
    find_events(detect_location)
    authorize Event
  end

  def past
    find_past_events
    authorize Event
  end

  def show
    find_event
    authorize @event
  end

  def new
    @event = Event.new
    authorize @event
  end

  def create
    authorize Event.new
    result = ::Events::Create.call(
      location: current_location,
      user: current_user,
      event_params: event_params
    )

    if result.success?
      flash[:success] = "Event created."
      turbolinks_redirect(event_path(result.event), action: "replace")
    else
      flash[:error] = result.message
      @event = Event.new(event_params)
    end
  end

  def edit
    find_event
    authorize @event
  end

  def update
    find_event
    authorize @event

    result = ::Events::Update.call(
      event: @event,
      location: current_location,
      user: current_user,
      event_params: event_params
    )

    if result.success?
      flash[:success] = "Event updated."
      turbolinks_redirect(event_path(result.event), action: "replace")
    else
      flash[:error] = result.message
      render :edit
    end
  end

  def destroy
    find_event
    authorize @event

    result = ::Events::Cancel.call(event: @event, operator: current_tenant)

    if result.success?
      flash[:success] = "Event cancelled."
      turbolinks_redirect(events_path, action: "replace")
    else
      flash[:error] = result.message
      turbolinks_redirect(event_path(@event), action: "replace")
    end
  end

  def detect_location
    if current_location.present?
      current_location
    else
      if params[:location_id].present?
        loc = current_tenant.locations.find(params[:location_id])
        if loc.present?
          set_location(loc)
          loc
        else
          raise "Invalid location ID."
        end
      else
        raise "Invalid location."
      end
    end
  end
end