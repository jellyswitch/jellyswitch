# typed: false
class Operator::InvoicesController < Operator::BaseController
  before_action :background_image
  def index
    @pagy, @invoices = pagy(Invoice.all.order('date DESC'))
    authorize @invoices
    @title = "All Invoices"
    render :generic
  end

  def recent
    @pagy, @invoices = pagy(Invoice.recent.order('date DESC'))
    authorize @invoices
    @title = "Recent Invoices"
    render :generic
  end

  def delinquent
    @pagy, @invoices = pagy(Invoice.delinquent.order('date DESC'))
    authorize @invoices
    @title = "Delinquent Invoices"
    render :generic
  end

  def groups
    @pagy, @invoices = pagy(Invoice.groups.order('date DESC'))
    authorize @invoices
    @title = "Group Invoices"
    render :generic
  end

  def open
    @pagy, @invoices = pagy(Invoice.open.order('date DESC'))
    authorize @invoices
    @title = "Open Invoices"
    render :generic
  end

  def charge
    find_invoice(:invoice_id)
    authorize @invoice

    result = Billing::Invoices::ChargeInvoice.call(
      invoice: @invoice,
      operator: @invoice.operator
    )

    if result.success?
      flash[:success] = "Charge succeeded."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(referrer_or_root, action: "replace")
  end

  def new
    authorize Invoice.new
    
    if params[:user_id].present?
      @billable = current_tenant.users.find(params[:user_id])
    elsif params[:organization_id].present?
      @billable = current_tenant.organizations.find(params[:organization_id])
    else
      flash[:error] = "Create a new invoice from a member or group's profile."
      turbolinks_redirect(invoices_path, action: "replace")
    end

    @invoice = @billable.invoices.new

    unless @billable
      flash[:error] = "Create a new invoice from a customer's profile page."
      turbolinks_redirect(invoices_path, action: "replace")
    end
  end

  def create
    authorize Invoice.new

    if params[:billable_type] == "User"
      @billable = current_tenant.users.find(params[:billable_id])
    elsif params[:billable_type] == "Organization"
      @billable = current_tenant.organizations.find(params[:billable_id])
    else
      flash[:error] = "No such member or group."
      turbolinks_redirect(root_path)
    end

    if @billable
      result = Billing::Invoices::Custom::Create.call(
        billable: @billable,
        amount: params[:amount],
        description: params[:description]
      )

      if result.success?
        flash[:success] = "Invoice created."
        turbolinks_redirect(billable_path(@billable))
      else
        flash[:error] = result.message
        @invoice = @billable.invoices.new
        render :new
      end
    else
      flash[:error] = "No such member or group."
      turbolinks_redirect(root_path)
    end
  end

  private

  def find_invoice(key=:id)
    @invoice = Invoice.find(params[key])
  end

  def billable_path(billable)
    case billable.class.name
    when "User"
      user_path(billable)
    when "Organization"
      organization_path(billable)
    else
      raise "No such billable type."
    end
  end
end