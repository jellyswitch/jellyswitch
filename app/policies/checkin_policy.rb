# typed: true
class CheckinPolicy < ApplicationPolicy
  def new?
    true
  end

  def required?
    true
  end

  def create?
    true
  end

  def show?
    admin?
  end

  def index?
    admin?
  end

  def destroy?
    owner? || admin?
  end
end