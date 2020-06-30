# typed: true
module Reservable
  class DefaultReservation < SimpleDelegator
    attr_accessor :reservation

    def initialize(reservation)
      @reservation = reservation
    end

    def invoice_args
      {
        customer: reservation.user.stripe_customer_id,
        auto_advance: true
      }
    end
  end
end