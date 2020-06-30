class MemberOnboarding::Membership < ApplicationComponent
  include PlansHelper

  def initialize(plan:)
    @plan = plan
  end

  private

  def credit_enabled?
    plan.operator.credits_enabled?
  end

  attr_reader :plan
end