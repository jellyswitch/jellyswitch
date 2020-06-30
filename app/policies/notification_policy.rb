class NotificationPolicy < ApplicationPolicy
  def reservations?
    operator.reservation_notifications?
  end

  def memberships?
    operator.membership_notifications?
  end

  def day_passes?
    operator.day_pass_notifications?
  end

  def member_feedback?
    operator.member_feedback_notifications?
  end

  def signups?
    operator.signup_notifications?
  end

  def checkins?
    operator.checkin_notifications?
  end

  def refunds?
    operator.refund_notifications?
  end

  def posts?
    operator.post_notifications?
  end
end