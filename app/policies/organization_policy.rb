# typed: true
class OrganizationPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin? || user.organization_owner?
  end

  def new?
    admin?
  end

  def create?
    admin?
  end

  def edit?
    admin? || user.organization_owner?
  end

  def update?
    admin?
  end

  def destroy?
    admin?
  end

  def credit_card?
    (admin? || user.organization_owner?) && record.card_added?
  end

  def out_of_band?
    admin? || user.organization_owner?
  end

  def billing?
    admin? || user.organization_owner?
  end

  def payment_method?
    admin? || user.organization_owner?
  end

  def members?
    admin? || user.organization_owner?
  end

  def leases?
    admin? || user.organization_owner?
  end

  def invoices?
    admin? || user.organization_owner?
  end

  def ltv?
    admin?
  end
end
