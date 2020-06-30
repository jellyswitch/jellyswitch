class Onboarding::CreateAdmin
  include Interactor
  include ErrorsHelper

  delegate :email, :operator, to: :context

  def call
    user = User.new(
      email: email,
      password: "foobar",
      admin: true, 
      operator_id: operator.id
    )

    if user.save
      user.profile_photo.attach(io: image = File.open(Rails.root.join("app/assets/images/avatars/1.jpg")), filename: "1.jpg")
      context.user = user
    else
      context.fail!(message: errors_for(user))
    end
  end

  def rollback
    context.user.destroy
  end
end