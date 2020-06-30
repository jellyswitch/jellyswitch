class Onboarding::UpdateUserNameAndPassword
  include Interactor
  include ErrorsHelper

  delegate :user, :name, :phone, :password, to: :context

  def call
    user.name = name
    user.password = password
    user.phone = phone

    unless user.save
      context.fail!(errors_for(user))
    end
  end
end