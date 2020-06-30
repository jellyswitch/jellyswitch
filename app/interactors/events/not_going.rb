class Events::NotGoing
  include Interactor
  include EventHelper

  delegate :event, :user, to: :context

  def call
    if rsvped?(user, event)
      if !rsvp(user, event).update(going: false)
        context.fail!(message: "Could not RSVP to this event.")
      end
    else
      if !event.rsvps.create!(user: user, going: false)
        context.fail!(message: "Could not RSVP to this event.")
      end      
    end
  end
end