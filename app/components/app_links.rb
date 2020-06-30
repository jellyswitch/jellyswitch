class AppLinks < ApplicationComponent
  def initialize(operator:)
    @operator = operator
  end

  private

  attr_reader :operator
end