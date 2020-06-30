class Layout::Freola::ColorfulBackgroundCard < ApplicationComponent
  def initialize(title:, body:)
    @title = title
    @body = body
  end

  private

  attr_reader :title, :body
end