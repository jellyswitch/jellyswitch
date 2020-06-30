class MemberOnboarding::Rooms < ApplicationComponent
  include SignUpHelper
  include ApplicationHelper

  def initialize(rooms:)
    @rooms = rooms
  end

  private

  attr_reader :rooms
end