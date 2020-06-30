class Operator::NotificationsController < Operator::BaseController
  before_action :background_image

  def index
  end

  def reservations
    setting(:reservation_notifications)
  end

  def memberships
    setting(:membership_notifications)
  end

  def day_passes
    setting(:day_pass_notifications)
  end

  def signups
    setting(:signup_notifications)
  end

  def checkins
    setting(:checkin_notifications)
  end

  def refunds
    setting(:refund_notifications)
  end

  def posts
    setting(:post_notifications)
  end

  def feedback
    setting(:member_feedback_notifications)
  end

  private

  def setting(symbol)
    result = ToggleValue.call(object: current_tenant, value: symbol)
    
    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(notifications_path, action: "replace")
  end
end