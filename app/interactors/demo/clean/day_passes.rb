class Demo::Clean::DayPasses
  include Interactor

  delegate :operator, to: :context

  def call
    operator.day_passes.destroy_all
  end
end