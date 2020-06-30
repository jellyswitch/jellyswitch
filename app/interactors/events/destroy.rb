class Events::Destroy
  include Interactor

  delegate :event, to: :context

  def call
    event.rsvps.destroy_all
    event.destroy
  end
end