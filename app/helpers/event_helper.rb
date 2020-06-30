module EventHelper
  def find_events(location)
    @events = location.events.future.order("starts_at ASC").group_by_day(&:starts_at)
  end

  def find_past_events
    @events = current_location.events.past.order("starts_at ASC").group_by_day(reverse: true) { |i| i.starts_at }
  end

  def find_upcoming_events
    @events = current_location.events.future.limit(1).order("starts_at ASC").group_by_day(&:starts_at)
  end

  def find_todays_events
    @events = current_location.events.today.order("starts_at ASC")
  end

  def find_event
    if current_location.present?
      @event = current_location.events.find(params[:id])
    else
      @event = Event.find(params[:id])
    end
  end

  def event_params
    p = params.require(:event).permit(:title, :description, :starts_at, :ends_at, :image, :location_string)
  end

  def rsvped?(user, event)
    rsvp(user, event).present?
  end

  def rsvp(user, event)
    found = event.rsvps.for_user(user).for_event(event)
    if found.count > 0
      found.first
    else
      nil
    end
  end

  def pretty_location(event)
    if event.location_string.present?
      event.location_string.titleize
    else
      event.location.name.titleize
    end
  end
end