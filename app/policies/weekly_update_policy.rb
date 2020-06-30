# typed: true
class WeeklyUpdatePolicy < ApplicationPolicy
  def index?
    admin?
  end

  def create?
    admin?
  end

  def show?
    admin?
  end

  def new?
    user.id == User.first.id # only dave can do this
  end
end