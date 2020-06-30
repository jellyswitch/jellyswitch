
class UserMailerPreview < ActionMailer::Preview
  def password_reset
    UserMailer.password_reset(User.first, User.first.operator)
  end

  def onboarding
    UserMailer.onboarding(User.first, "pizza123")
  end

  def event_registration
    UserMailer.event_registration(User.first, "pizza123", Event.last)
  end

  def event_cancellation
    UserMailer.event_cancellation(User.first, Event.last.title, Event.last.location.operator)
  end
end