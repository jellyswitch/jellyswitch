class HourLabel < ApplicationComponent
  include ApplicationHelper
  
  def initialize(hours:)
    @hours = hours
  end

  private

  attr_accessor :hours
end