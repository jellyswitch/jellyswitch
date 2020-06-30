# typed: true
class DoorPunchPolicy < ApplicationPolicy
  def show?
    admin?
  end
end