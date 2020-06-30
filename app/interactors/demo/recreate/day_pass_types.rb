class Demo::Recreate::DayPassTypes
  include Interactor

  delegate :operator, to: :context

  def call
    day_pass_types.each do |dpt|
      result = CreateDayPassType.call(
        params: dpt,

      )

      if !result.success?
        context.fail!(message: result.message)
      end
    end
  end

  private

  def day_pass_types
    [
      {
        name: "Standard Day Pass",
        amount_in_cents: 3000,
        available: true,
        visible: true,
        operator_id: operator.id
      },
      {
        name: "Student Day Pass",
        amount_in_cents: 1500,
        available: true,
        visible: false,
        code: "STUDENT123",
        operator_id: operator.id
      },
    ]
  end
end