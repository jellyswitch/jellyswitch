class Layout::Freola::FlatIcon < ApplicationComponent
  def initialize(title:, body:, footer_text:, footer_link:, icon:)
    @title = title
    @body = body
    @footer_text = footer_text
    @footer_link = footer_link
    @icon = icon
  end

  private

  attr_reader :title, :body, :footer_text, :footer_link

  def icon_path
    case @icon
    when :group
      "https://www.jellyswitch.com/wp-content/uploads/2019/12/Group-809.svg"
    when :build
      "https://www.jellyswitch.com/wp-content/uploads/2019/11/features-we-dont-integrate-we-build-1.svg"
    end
  end
end