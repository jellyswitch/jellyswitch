# typed: true
class FeedItemPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def questions?
    admin?
  end

  def activity?
    admin?
  end

  def notes?
    admin?
  end

  def financial?
    admin?
  end

  def create?
    admin?
  end

  def show?
    admin?
  end

  def destroy?
    admin?
  end
end