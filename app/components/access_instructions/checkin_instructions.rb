class AccessInstructions::CheckinInstructions < ApplicationComponent
  def initialize(operator:, location:)
    @operator = operator
    @location = location
  end

  private

  attr_reader :operator, :location

end