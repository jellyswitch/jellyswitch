class Bootstrap::BreadcrumbItem < ApplicationComponent
  def initialize(label:, active:, path:)
    @label = label
    @active = active
    @path = path
  end

  private

  attr_accessor :label, :active, :path
end