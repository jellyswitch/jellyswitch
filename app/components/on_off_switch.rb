class OnOffSwitch < ApplicationComponent
  def initialize(predicate:, path:, disabled: false, label: nil)
    @predicate = predicate
    @path = path
    @disabled = disabled
    @label = label
  end

  private

  attr_reader :predicate, :path, :disabled, :label
  
  def icon_class
    if predicate
      "fas fa-toggle-on"
    else
      "fas fa-toggle-off"
    end
  end
end