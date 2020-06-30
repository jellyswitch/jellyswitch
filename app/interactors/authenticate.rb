class Authenticate
  include Interactor

  delegate :operator, :email, :password, to: :context

  def call
    user = User.find_by_operator(email: email, operator_id: operator.id)
    context.user = user
    
    if user.present?
      if !user.authenticate(password)
        context.fail!(message: "Invalid password.")
      end
    else
      context.fail!(message: "Please check that your email and password are accurate.")
    end
  end
end