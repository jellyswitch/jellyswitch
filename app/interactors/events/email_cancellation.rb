class Events::EmailCancellation
  include Interactor

  delegate :event, :operator, to: :context

  def call
    event.rsvps.going.each do |rsvp|
      UserMailer.event_cancellation(rsvp.user, event.title, operator).deliver_later
    end
  end
end