# typed: true
class UserContext
  attr_reader :user, :operator, :location

  def initialize(user, operator, location)
    @user = user
    @operator = operator
    @location = location
  end

  def admin?
    @user.admin?
  end

  def present?
    @user.present?
  end

  def superadmin?
    @user.superadmin?
  end
end