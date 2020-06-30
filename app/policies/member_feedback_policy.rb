# typed: true
class MemberFeedbackPolicy < ApplicationPolicy
  def new?
    is_user?
  end

  def create?
    is_user?
  end

  def index?
    admin?
  end

  def show?
    admin?
  end
end