# typed: true
class CancelReservation
  include Interactor

  def call
    reservation = context.reservation

    reservation.cancelled = true

    if !reservation.save
      context.fail!(message: "Unable to cancel reservation.")
    end
  end
end