class MemberOnboarding::Checkin < ApplicationComponent
  include SignUpHelper
  include ApplicationHelper

  def initialize(location:, has_billing:)
    @location = location
    @has_billing = has_billing
  end

  private

  attr_reader :location, :has_billing
end