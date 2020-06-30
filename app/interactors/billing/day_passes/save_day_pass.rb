# typed: true
class Billing::DayPasses::SaveDayPass
  include Interactor

  delegate :day_pass, :token, :operator, :out_of_band, :params, :user_id, to: :context

  def call
    user = User.find(user_id)
    if user.nil?
      context.fail!(message: "No such user with ID #{user_id}")
    end
    context.user = user

    day_pass_type = DayPassType.find(params[:day_pass_type].to_i)
    if day_pass_type.nil?
      context.fail!(message: "Invalid day pass type.")
    end

    day_pass = DayPass.new(params.merge({day_pass_type: day_pass_type}))
    day_pass.user = user
    day_pass.billable = BillableFactory.for(day_pass).billable

    context.fail!(message: "Cannot create day pass for user without billing info.") unless day_pass.billable.has_stripe_customer?

    if !day_pass.save
      context.fail!(message: "Unable to create day pass.")
    end
    context.day_pass = day_pass
  end

  def rollback
    context.day_pass.destroy
  end
end