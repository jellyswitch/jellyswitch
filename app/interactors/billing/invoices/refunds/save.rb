# typed: true
class Billing::Invoices::Refunds::Save
  include Interactor
  include FeedItemCreator
  delegate :operator, :invoice, to: :context

  def call
    billable = invoice.billable

    if invoice.cancel
      blob = { type: 'refund', invoice_id: invoice.id }
      create_feed_item(operator, billable, blob)
    else
      context.fail!(message: 'Failed to refund invoice')
    end
  end
end
