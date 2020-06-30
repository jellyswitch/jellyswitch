# typed: true
class ChildcarePolicy < ApplicationPolicy
  def enabled?
    operator.childcare_enabled?
  end
end