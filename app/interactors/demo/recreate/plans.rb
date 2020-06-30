class Demo::Recreate::Plans
  include Interactor

  delegate :operator, to: :context

  def call
    plans.each do |plan|
      result = Billing::Plans::CreatePlan.call(
        plan: Plan.new(plan),
        operator: operator
      )
      if !result.success?
        context.fail!(message: result.message)
      end
    end
  end

  private

  def plans
    [
      {
        name: "Dedicated Desk",
        amount_in_cents: 50000,
        interval: "monthly",
        plan_type: "individual",
        available: true,
        visible: true,
        operator_id: operator.id,
        location_ids: operator.locations.map(&:id)
      },
      {
        name: "Full Time Membership",
        amount_in_cents: 35000,
        interval: "monthly",
        plan_type: "individual",
        available: true,
        visible: true,
        operator_id: operator.id,
        location_ids: operator.locations.map(&:id)
      },
      {
        name: "Part Time Membership",
        amount_in_cents: 20000,
        interval: "monthly",
        plan_type: "individual",
        available: true,
        visible: true,
        operator_id: operator.id,
        location_ids: operator.locations.map(&:id)
      },
    ]
  end
end