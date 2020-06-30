# typed: true
class DayPassable::InBand < DayPassable::DefaultDayPass
  def invoice_args
    super.merge!(
      billing: 'charge_automatically'
    )
  end
end