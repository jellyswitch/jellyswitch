class LeadPolicy < ApplicationPolicy
  def index?
    can_see?
  end

  def new?
    can_see?
  end

  def create?
    can_see?
  end

  def edit?
    can_see?
  end

  def update?
    can_see?
  end

  def show?
    can_see?
  end

  def enabled?
    operator.crm_enabled?
  end

  def can_see?
    enabled? && admin?
  end
end