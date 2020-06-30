# typed: true

class Reservable::InBand < Reservable::DefaultReservation
  def invoice_args
    super.merge!(
      billing: 'charge_automatically'
    )
  end
end