class AnnouncementPolicy < ApplicationPolicy
  def index?
    enabled? && (billing_disabled? || admin? || (user.member_at_operator?(operator) && approved?))
  end

  def new?
    enabled? && admin?
  end

  def create?
    enabled? && admin?
  end

  def enabled?
    operator.announcements_enabled?
  end

  private

  def can_see_announcements?
    admin? || (user.allowed_in?(location) && user.approved?)
  end
end