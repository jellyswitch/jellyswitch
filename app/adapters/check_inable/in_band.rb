# typed: true
class CheckInable::InBand < CheckInable::DefaultCheckin
  def invoice_args
    super.merge!(
      billing: 'charge_automatically'
    )
  end
end