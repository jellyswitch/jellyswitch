# typed: true
class ReservationPolicy < ApplicationPolicy
  def new?
    admin? || ((user.allowed_in?(location) && approved?) || billing_disabled?)
  end

  def create?
    admin? || ((user.allowed_in?(location) && approved?) || billing_disabled?)
  end

  def show?
    admin? || owner?
  end

  def destroy?
    admin? || ((user.allowed_in?(location) && approved?) || billing_disabled?)
  end

  def cancel?
    admin? || (owner? && future?)
  end

  def long_duration?
    admin?
  end

  def today?
    admin?
  end

  private

  def future?
    record.datetime_in > Time.zone.now
  end
end