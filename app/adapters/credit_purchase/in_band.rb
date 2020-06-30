# typed: true
class CreditPurchase::InBand < CreditPurchase::DefaultCreditPurchase
  def invoice_args
    super.merge!(
      billing: 'charge_automatically'
    )
  end
end