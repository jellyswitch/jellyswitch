class MemberOnboarding::DayPassItem < ApplicationComponent
  include SignUpHelper
  include ApplicationHelper

  def initialize(day_pass_type:)
    @day_pass_type = day_pass_type
  end

  private

  attr_reader :day_pass_type
end