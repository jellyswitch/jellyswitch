# typed: false
class Operator::RefundsController < Operator::BaseController

  def create
    invoice = Invoice.find(params[:invoice_id])

    refundable_invoice = RefundableFactory.for(invoice)

    result = Billing::Invoices::Refunds::Create.call(operator: current_tenant, invoice: refundable_invoice)

    if result.success?
      flash[:notice] = "Successfully refunded invoice"
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(invoices_path, action: "replace")
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end
end
