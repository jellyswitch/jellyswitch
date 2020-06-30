# typed: ignore
class OnboardingPolicy < Struct.new(:user, :onboarding)
  include PolicyHelpers

  def show?
    admin?
  end
end
