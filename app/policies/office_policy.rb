# typed: true
class OfficePolicy < ApplicationPolicy
  def index?
    enabled? && admin?
  end

  def show?
    enabled? && admin?
  end

  def new?
    enabled? && admin?
  end

  def create?
    enabled? && admin?
  end

  def edit?
    enabled? && admin?
  end

  def update?
    enabled? && admin?
  end

  def available?
    enabled? && admin?
  end

  def upcoming_renewals?
    enabled? && admin?
  end

  def enabled?
    operator.offices_enabled?
  end
end
