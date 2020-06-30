# typed: true
class SessionPolicy < ApplicationPolicy
  def new?
    !(record.present? && record.class == User) # record is a user
  end

  def create?
    !(record.present? && record.class == User) # record is a user
  end
end