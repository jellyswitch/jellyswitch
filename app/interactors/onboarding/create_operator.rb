class Onboarding::CreateOperator
  include Interactor
  include ErrorsHelper

  delegate :email, to: :context

  def call
    operator = Operator.new(
      name: email,
      skip_onboarding: true,
      offices_enabled: false
    )

    if operator.save
      context.operator = operator
    else
      context.fail!(message: errors_for(operator))
    end
  end

  def rollback
    context.operator.destroy
  end
end