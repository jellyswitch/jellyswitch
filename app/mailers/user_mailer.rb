# typed: true
class UserMailer < ApplicationMailer
  helper ApplicationHelper
  helper LayoutHelper

  def password_reset(user, operator)
    @user = user
    @operator = operator

    mail to: user.email, subject: "#{@operator.name} password reset", from: @operator.contact_email
    recipients = User.superadmins.all.map {|u| u.email }
  end

  def event_registration(user, password, event)
    @user = user
    @password = password
    @event = event

    from_addr = @user.operator.contact_email
    if from_addr.blank?
      from_addr = "noreply@jellyswitch.com"
    end
    @host = ENV['ASSET_HOST']
    mail to: @user.email, subject: "You're all set for #{@event.title}!", from: from_addr
  end

  def event_cancellation(user, event_name, operator)
    @user = user
    @event_name = event_name
    @operator = operator

    from_addr = @user.operator.contact_email
    if from_addr.blank?
      from_addr = "noreply@jellyswitch.com"
    end
    
    @host = ENV['ASSET_HOST']
    mail to: @user.email, subject: "Cancelled: #{@event_name}", from: from_addr
  end
end