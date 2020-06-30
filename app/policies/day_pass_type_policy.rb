# typed: true
class DayPassTypePolicy < ApplicationPolicy
  def index?
    admin? && billing_enabled?
  end

  def show?
    admin? && billing_enabled?
  end

  def edit?
    admin? && billing_enabled?
  end

  def new?
    admin? && billing_enabled?
  end

  def create?
    admin? && billing_enabled?
  end

  def update?
    admin? && billing_enabled?
  end

  def destroy?
    admin? && billing_enabled?
  end
end