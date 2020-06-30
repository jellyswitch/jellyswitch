class Demo::SelectOperator
  include Interactor

  delegate :subdomain, to: :context

  def call
    operator = Operator.find_by(subdomain: subdomain)

    if operator
      if operator.production? && operator.subdomain != "southlakecoworking"
        context.fail!(message: "Can't run task on production instance: #{operator.name}")
      else
        context.operator = operator
      end
    else
      context.fail!(message: "Could not find operator with subdomain: #{subdomain}.")
    end
  end
end