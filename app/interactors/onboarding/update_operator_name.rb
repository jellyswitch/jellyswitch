class Onboarding::UpdateOperatorName
  include Interactor
  include ErrorsHelper

  delegate :user, :operator_name, to: :context

  def call
    operator = user.operator
    operator.name = operator_name
    operator.subdomain = operator_name.parameterize
    context.operator = operator
    unless operator.save
      context.fail!(message: errors_for(operator))
    end
  end
end