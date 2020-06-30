# typed: ignore
class DashboardPolicy < Struct.new(:user, :dashboard)
  include PolicyHelpers

  def show?
    admin?
  end
end