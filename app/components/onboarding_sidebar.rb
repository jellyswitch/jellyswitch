class OnboardingSidebar < ApplicationComponent
  include LayoutHelper

  def initialize(operator:, location:)
    @operator = operator
    @location = location
  end

  private

  attr_reader :operator, :location

  def billing_enabled?
    operator.production? && operator.subdomain != "southlakecoworking"
  end

  def show_day_pass_types?
    billing_enabled? && operator.day_pass_types.count < 1
  end

  def show_rooms?
    billing_enabled? && operator.rooms_enabled? && location.rooms.count < 1
  end

  def show_doors?
    billing_enabled? && operator.door_integration_enabled? && location.doors.count < 1
  end

  def show_members?
    billing_enabled? && operator.users.members.count < 1
  end
end