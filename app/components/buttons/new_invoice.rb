class Buttons::NewInvoice < ApplicationComponent
  validates :user, presence: true

  def initialize(user: nil, classes: "")
    @user = user
    @classes = classes
  end

  private
  
  attr_reader :user, :classes
end