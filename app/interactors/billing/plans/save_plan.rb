# typed: true
class Billing::Plans::SavePlan
  include Interactor

  delegate :plan, :operator, to: :context

  def call
    unless plan.save
      context.fail!(message: "Couldn't save plan.")
    end
  end

  def rollback
    context.plan.destroy
  end
end