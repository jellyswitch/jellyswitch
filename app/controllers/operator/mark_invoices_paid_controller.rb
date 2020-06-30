# typed: false
class Operator::MarkInvoicesPaidController < Operator::BaseController
  def update
    invoice = Invoice.find(params[:invoice_id])

    result = Billing::Invoices::MarkInvoiceAsPaid.call(
      invoice: invoice, 
      operator: current_tenant)

    if result.success?
      flash[:success] = "Invoice marked as paid."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(invoices_path)
  end
end
