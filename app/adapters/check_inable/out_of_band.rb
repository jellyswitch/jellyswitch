# typed: true
class CheckInable::OutOfBand < CheckInable::DefaultCheckin
def invoice_args
    super.merge!(
      billing: 'send_invoice',
      days_until_due: 30
    )
  end
end