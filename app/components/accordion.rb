class Accordion < ApplicationComponent
  def initialize(title:)
    @title = title
  end

  private

  attr_reader :title

  def id
    @id ||= "accordion-#{num}"
  end

  def header_id
    @header_id ||= "accordion-header-#{num}"
  end
  
  def collapse_id
    @collapse_id ||= "accordion-collapse-#{num}"
  end

  def num
    @num ||= rand(1000)
  end
end