class ChildcareReservationPolicy < ApplicationPolicy
  def index?
    enabled? && admin?
  end

  def new?
    enabled?
  end

  def create?
    enabled?
  end

  def show?
    enabled? && admin_or_owner?
  end

  def destroy?
    enabled? && ((future? && owner?) || admin?)
  end

  def enabled?
    operator.childcare_enabled?
  end

  def confirm?
    enabled?
  end

  private

  def admin_or_owner?
    admin? || owner?
  end

  def future?
    record.date > Time.zone.now
  end

  def owner?
    record.child_profile.user == user
  end
end