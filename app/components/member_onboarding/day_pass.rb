class MemberOnboarding::DayPass < ApplicationComponent
  include SignUpHelper
  def initialize(day_pass_types:, new_day_pass_path:, location:)
    @day_pass_types = day_pass_types
    @new_day_pass_path = new_day_pass_path
    @location = location
  end

  private

  attr_reader :day_pass_types, :new_day_pass_path, :location
end