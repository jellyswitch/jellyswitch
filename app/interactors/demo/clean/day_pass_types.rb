class Demo::Clean::DayPassTypes
  include Interactor

  delegate :operator, to: :context

  def call
    operator.day_pass_types.destroy_all
  end
end