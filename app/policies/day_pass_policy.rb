# typed: true
class DayPassPolicy < ApplicationPolicy
  def index?
    is_user? && billing_enabled?
  end

  def new?
    is_user? && billing_enabled?
  end

  def create?
    (is_user? && billing_enabled?) || admin?
  end

  def show?
    (owner? || admin?) && billing_enabled?
  end

  def code?
    is_user? && billing_enabled?
  end

  def redeem_code?
    is_user? && billing_enabled?
  end
end