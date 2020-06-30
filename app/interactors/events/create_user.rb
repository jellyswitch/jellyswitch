class Events::CreateUser
  include Interactor

  delegate :event, :email, to: :context

  def call
    validate!

    result = ::Users::Create.call(
      params: {
        name: email,
        email: email,
        password: "pizza123",
        password_confirmation: "pizza123"

      },
      operator: event.location.operator
    )

    if !result.success?
      context.fail!(message: result.message)
    end

    context.user = result.user

    result = Events::SetPasswordAndSendEmail.call(user: result.user, event: event)

    if !result.success?
      context.fail!(message: result.message)
    end
  end

  def validate!
    context.fail!(message: "Please enter an email address.") unless email.present?
    context.fail!(message: "That email address already has an account. Please log in instead.") if event.location.operator.users.find_by(email: email).present?
  end
end