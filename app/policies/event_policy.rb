# typed: true
class EventPolicy < ApplicationPolicy
  def index?
    enabled?
  end

  def past?
    enabled?
  end

  def new?
    enabled? && admin?
  end

  def create?
    enabled? && admin?
  end

  def show?
    enabled?
  end

  def edit?
    enabled? && admin?
  end

  def update?
    enabled? && admin?
  end

  def destroy?
    enabled? && admin?
  end

  def rsvp?
    enabled? && future?
  end
  
  def future?
    record.starts_at >= Time.current
  end

  def enabled?
    operator.events_enabled?
  end
end