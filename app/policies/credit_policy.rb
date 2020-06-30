# typed: true
class CreditPolicy < ApplicationPolicy
  def enabled?
    operator.credits_enabled?
  end

  def new?
    enabled?
  end

  def create?
    enabled?
  end

  def confirm?
    enabled?
  end
end