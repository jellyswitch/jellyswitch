class AccessInstructions::DoorButtons < ApplicationComponent
  include ApplicationHelper

  def initialize(operator:, location:, mobile_app_request:, has_access:, doors:)
    @operator = operator
    @location = location
    @mobile_app_request = mobile_app_request
    @has_access = has_access
    @doors = doors
  end

  private

  attr_reader :operator, :location, :mobile_app_request, :has_access, :doors
end