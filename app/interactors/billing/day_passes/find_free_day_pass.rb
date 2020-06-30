# typed: true
class Billing::DayPasses::FindFreeDayPass
  include Interactor

  delegate :user, :location, to: :context

  def call
    day_pass_types = DayPassType.for_operator(location.operator).free.available

    if day_pass_types.count < 1
      day_pass_type = DayPassType.create!(
        operator_id: location.operator.id,
        amount_in_cents: 0,
        visible: false,
        available: true,
        name: "[Automatic] Free Day Pass"
      )
    else
      day_pass_type = day_pass_types.first
    end

    context.day_pass_type = day_pass_type
    context.token = nil
    context.operator = location.operator
    context.out_of_band = false
    context.user_id = user.id
    context.params = {
      day_pass_type: day_pass_type.id,
      day: Time.current
    }

  end

  def rollback
    context.day_pass_type.destroy
  end
end