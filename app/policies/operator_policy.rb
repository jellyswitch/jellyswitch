# typed: true
class OperatorPolicy < ApplicationPolicy
  def index?
    superadmin?
  end

  def new?
    superadmin?
  end

  def show?
    superadmin? || operator?
  end

  def edit?
    superadmin? || operator?
  end

  def update?
    superadmin? || operator?
  end

  def create?
    superadmin?
  end

  def demo_instance?
    superadmin?
  end

  def destroy?
    superadmin?
  end
end