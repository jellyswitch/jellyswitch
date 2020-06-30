# typed: true
class LocationPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def new?
    admin?
  end

  def show?
    admin?
  end

  def create?
    admin?
  end

  def edit?
    admin?
  end

  def update?
    admin?
  end

  def allow_hourly?
    admin?
  end

  def new_users_get_free_day_pass?
    admin?
  end

  def visible?
    admin?
  end
end
