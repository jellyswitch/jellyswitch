class Demo::Clean::Announcements
  include Interactor

  delegate :operator, to: :context

  def call
    operator.announcements.destroy_all
  end
end