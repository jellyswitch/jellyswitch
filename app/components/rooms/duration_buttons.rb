class Rooms::DurationButtons < ApplicationComponent
  include ApplicationHelper

  def initialize(room:, datetime_in:, day:, hour:, user:)
    @room = room
    @datetime_in = datetime_in
    @day = day
    @hour = hour
    @user = user
  end

  private

  attr_reader :room, :datetime_in, :day, :hour, :user
end