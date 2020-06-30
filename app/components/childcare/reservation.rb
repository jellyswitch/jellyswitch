class Childcare::Reservation < ApplicationComponent
  include ApplicationHelper
  
  def initialize(childcare_reservation:)
    @childcare_reservation = childcare_reservation
  end

  private

  attr_accessor :childcare_reservation
end