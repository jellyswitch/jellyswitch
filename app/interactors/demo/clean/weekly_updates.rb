class Demo::Clean::WeeklyUpdates
  include Interactor

  delegate :operator, to: :context

  def call
    operator.weekly_updates.destroy_all
  end
end