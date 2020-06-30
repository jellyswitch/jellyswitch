# typed: false
module Refundable
  class VoidableInvoice < SimpleDelegator
    def cancel
      stripe_invoice = operator.retrieve_stripe_invoice(self)

      case stripe_invoice.status
      when 'draft'
        stripe_invoice.delete
      when 'open'
        stripe_invoice.void_invoice
      end

      update(status: 'void')
    end
  end
end
