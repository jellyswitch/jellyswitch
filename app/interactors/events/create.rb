class Events::Create
  include Interactor

  delegate :event_params, :user, :location, to: :context

  def call
    params = context.event_params.merge!({
      user: user,
      location: location
    })

    if params[:starts_at].present?
      zone = ActiveSupport::TimeZone[location.time_zone]
      offset = zone.now.formatted_offset
      time_input = "#{params[:starts_at]} #{offset}"

      params[:starts_at] = Time.strptime(time_input, "%m/%d/%Y %l:%M %p %Z")
    else
      context.fail!(message: "You must provide a start date for your event.")
    end

    if params[:ends_at].present?
      zone = ActiveSupport::TimeZone[location.time_zone]
      offset = zone.now.formatted_offset
      time_input = "#{params[:ends_at]} #{offset}"

      params[:ends_at] = Time.strptime(time_input, "%m/%d/%Y %l:%M %p %Z")
    end

    event = Event.new(params)
    
    if event.save
      context.event = event
    else
      context.fail!(message: "Could not create event.")
    end
  end
end