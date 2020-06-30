# typed: true
class Billing::DayPasses::RedeemCode
  include Interactor

  delegate :code, :operator, to: :context

  def call
    day_pass_types = DayPassType.for_operator(operator).for_code(code)
    case day_pass_types.count
    when 0
      context.fail!(message: "We couldn't find a day pass for that code. Please check and try again.")
    when 1
      context.day_pass_type = day_pass_types.first
    else
      context.day_pass_type = day_pass_types.first
    end
  end
end