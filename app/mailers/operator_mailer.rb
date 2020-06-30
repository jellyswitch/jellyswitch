# typed: true
class OperatorMailer < ApplicationMailer
  default from: 'Dave at Jellyswitch <dave@jellyswitch.com>'
  def new_demo_instance(user, operator)
    @user = user
    @operator = operator
    
    mail to: @user.email, subject: "Your Jellyswitch demo is ready"
  end

  def new_operator_survey(operator_survey)
    @operator_survey = operator_survey

    recipients = User.superadmins.all.map {|u| u.email }
    mail to: recipients, subject: "New Jellyswitch demo"
  end
end