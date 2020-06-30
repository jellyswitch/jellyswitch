# typed: true
class RoomPolicy < ApplicationPolicy
  def index?
    enabled? && is_user?
  end

  def show?
    enabled? && if record.rentable?
      is_user?
    else
      admin? || 
      (user.allowed_in?(location) && approved?)
    end
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

  def enabled?
    operator.rooms_enabled?
  end
end