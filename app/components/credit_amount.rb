class CreditAmount < ApplicationComponent
  include ApplicationHelper

  def initialize(amount:)
    @amount = amount
  end

  private

  attr_reader :amount
end