# typed: true
class OperatorSurveyPolicy < ApplicationPolicy
  def new?
    admin?
  end

  def create?
    admin?
  end

  def index?
    superadmin?
  end

  def show?
    superadmin?
  end

  def wait?
    admin?
  end
end