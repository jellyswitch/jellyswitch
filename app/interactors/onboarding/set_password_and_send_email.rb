class Onboarding::SetPasswordAndSendEmail
  include Interactor
  include ErrorsHelper

  delegate :user, to: :context

  def call
    context.password = Faker::Science.element
    unless user.update(password: context.password, password_confirmation: context.password)
      context.fail!(message: "Unable to update password (#{errors_for(user)}).")
    end

    JellyswitchMail.new(user.operator, dry_run: !Rails.env.production?).onboarding(user, context.password)
  end
end