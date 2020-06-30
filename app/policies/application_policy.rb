# typed: true
class ApplicationPolicy
  attr_reader :user, :record, :operator, :location
  include PolicyHelpers

  def initialize(user, record)
    @user = user.class == UserContext ? user.user : user
    @record = record
    @operator = user.class == UserContext ? user.operator : nil
    @location = user.class == UserContext ? user.location : nil
  end

  def index?
    false
  end

  def show?
    false
  end

  def create?
    false
  end

  def new?
    create?
  end

  def update?
    false
  end

  def edit?
    update?
  end

  def destroy?
    false
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      scope.all
    end
  end

  protected
end
