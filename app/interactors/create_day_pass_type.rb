# typed: true
class CreateDayPassType
  include Interactor

  def call
    @day_pass_type = DayPassType.new(context.params)
    context.day_pass_type = @day_pass_type

    if !@day_pass_type.save
      context.fail!(message: "Couldn't save day pass type.")
    end
  end
end