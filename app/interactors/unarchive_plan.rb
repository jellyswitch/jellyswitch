# typed: true
class UnarchivePlan
  include Interactor

  def call
    @plan = context.plan
    validate
    @plan.available = true
    if !@plan.save
      context.fail!(message: "Failed to save plan.")
    end
  end

  def validate
    if @plan.available?
      context.fail!(message: "Cannot unarchive a plan that's already available.")
    end
  end
end
