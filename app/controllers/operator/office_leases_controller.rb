# typed: false
class Operator::OfficeLeasesController < Operator::BaseController
  before_action :find_office_lease, only: [:show]
  before_action :background_image, except: [:create, :update]

  def index
    @office_leases = OfficeLease.order(created_at: :desc)
    authorize @office_leases
  end

  def show
    authorize @office_lease
  end

  def new
    @office_lease = OfficeLease.new
    @office_lease.build_subscription
    @office_lease.subscription.build_plan
    find_organizations
    find_offices
    find_plans
    authorize @office_lease
  end

  def create
    @office_lease = current_location.office_leases.build(office_lease_params)

    authorize @office_lease

    result = Billing::Leasing::CreateOfficeLease.call(
      office_lease: @office_lease,
      operator: current_tenant,
      plan: @office_lease.subscription.plan
    )

    if result.success?
      flash[:notice] = "Office lease created."
      turbolinks_redirect(office_lease_path(result.office_lease))
    else
      flash[:error] = result.message
      find_organizations
      find_offices
      find_plans
      turbolinks_redirect(new_office_lease_path, action: "replace")
    end
  end

  def destroy
    find_office_lease
    authorize @office_lease

    result = Billing::Leasing::TerminateOfficeLease.call(
      office_lease: @office_lease,
      subscription: @office_lease.subscription
    )

    if result.success?
      flash[:success] = "This lease has been terminated. Any outstanding invoices may still need to be addressed."
    else
      flash[:error] = result.message
    end
    turbolinks_redirect(office_lease_path(@office_lease), action: "replace")
  end

  private

  def find_office_lease(key=:id)
    @office_lease = OfficeLease.find(params[key])
  end

  def office_lease_params
    params.require(:office_lease).permit(
      :organization_id,
      :office_id,
      :start_date,
      :lease_agreement,
      :end_date,
      :initial_invoice_date,
      subscription_attributes: [
        plan_attributes: [
          :name,
          :plan_type,
          :visible,
          :available,
          :interval,
          :amount_in_cents
          ]
        ]
    )
  end

  def find_organizations
    @organizations = Organization.all.select do |org|
      org.has_stripe_customer?
    end
  end

  def find_offices
    @offices = Office.available_for_lease
  end

  def find_plans
    @plans = Plan.lease
  end
end
