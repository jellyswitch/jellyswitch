# typed: true
class OfficeLeasePolicy < ApplicationPolicy
  def index?
    enabled? && admin?
  end

  def show?
    enabled? && (admin? || owner?)
  end

  def new?
    enabled? && admin?
  end

  def create?
    enabled? && admin?
  end

  def destroy?
    enabled? && admin?
  end

  def enabled?
    operator.offices_enabled?
  end

  private

  def owner?
    record.organization.owner == user
  end
end
