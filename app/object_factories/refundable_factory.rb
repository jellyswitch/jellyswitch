# typed: false
class RefundableFactory
  def self.for(invoice)
    if invoice.voidable?
      Refundable::VoidableInvoice
    elsif invoice.paid?
      Refundable::RefundableInvoice
    end.new(invoice)
  end
end
