# typed: true
class Billing::Reservations::SaveRoomReservation
  include Interactor
  include FeedItemCreator

  def call
    reservation = Reservation.new(context.reservation_params)

    reservation.user = context.user
    reservation.datetime_in = reservation.datetime_in.beginning_of_half_hour

    context.reservation = reservation
    context.notifiable = reservation

    if !reservation.save
      context.fail!(message: "Unable to save reservation.")
    end
  end
end