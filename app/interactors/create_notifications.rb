# typed: true
class CreateNotifications
  include Interactor

  delegate :notifiable, to: :context

  def call
    NotifiableFactory.for(notifiable).notify
  end
end
