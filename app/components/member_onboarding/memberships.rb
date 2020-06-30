class MemberOnboarding::Memberships < ApplicationComponent
  include SignUpHelper
  include ApplicationHelper

  def initialize(plans:, location:)
    @plans = plans
    @location = location
  end

  private

  attr_reader :plans, :location
end