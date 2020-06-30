# typed: true
class ChildProfilePolicy < ApplicationPolicy
  def index?
    true
  end

  def new?
    true
  end

  def create?
    true
  end

  def show?
    owner_or_admin?
  end

  def edit?
    owner_or_admin?
  end

  def update?
    owner_or_admin?
  end

  private

  def owner_or_admin?
    record.user == user || admin?
  end
end