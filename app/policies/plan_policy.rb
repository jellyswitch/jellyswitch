# typed: true
class PlanPolicy < ApplicationPolicy
  def index?
    admin? && billing_enabled?
  end

  def archived?
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

  def unarchive?
    admin? && billing_enabled?
  end

  def toggle_visibility?
    admin? && billing_enabled?
  end

  def toggle_availability?
    admin? && billing_enabled?
  end

  def toggle_building_access?
    admin? && billing_enabled?
  end
end