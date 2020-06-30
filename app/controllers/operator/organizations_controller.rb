# typed: false
class Operator::OrganizationsController < Operator::BaseController
  before_action :find_organization, except: [:index, :new, :create, :credit_card,
    :out_of_band, :billing, :payment_method, :members, :leases, :invoices, :ltv]

  def index
    find_organizations
    authorize @organizations
    background_image
  end

  def show
    authorize @organization
    background_image
  end

  def new
    @organization = Organization.new
    authorize @organization
    background_image
  end

  def create
    @organization = Organization.new(organization_params)
    authorize @organization

    result = CreateOrganization.call(organization: @organization, operator: current_tenant)

    if result.success?
      flash[:notice] = "Organization #{@organization.name} has been created."
      turbolinks_redirect(organization_path(@organization))
    else
      flash[:error] = result.message
      background_image
      render :new, status: 422
    end
  rescue => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def edit
    authorize @organization
    include_stripe
    background_image
  end

  def update
    authorize @organization

    @organization.update_attributes(organization_params)

    if @organization.save
      flash[:notice] = "The organization #{@organization.name} has been updated."
      turbolinks_redirect(organization_path(@organization))
    else
      background_image
      render :edit, status: 422
    end
  rescue => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def credit_card
    find_organization(:organization_id)
    authorize @organization

    if @organization.update(out_of_band: false)
      flash[:success] = "Payment method updated."
    else
      flash[:error] = "Could not update payment method."
    end

    turbolinks_redirect(organization_path(@organization), action: "replace")
  end

  def out_of_band
    find_organization(:organization_id)
    authorize @organization

    if @organization.update(out_of_band: true)
      flash[:success] = "Payment method updated."
    else
      flash[:error] = "Could not update payment method."
    end

    turbolinks_redirect(organization_path(@organization), action: "replace")
  end

  def billing
    find_organization(:organization_id)
    authorize @organization
    include_stripe
  end

  def payment_method
    find_organization(:organization_id)
    authorize @organization
  end

  def members
    find_organization(:organization_id)
    authorize @organization
  end

  def leases
    find_organization(:organization_id)
    authorize @organization
  end

  def invoices
    find_organization(:organization_id)
    authorize @organization
  end

  def ltv
    find_organization(:organization_id)
    authorize @organization

    @months = (Time.current.year * 12 + Time.current.month) - (@organization.created_at.year * 12 + @organization.created_at.month)
  end

  private

  def organization_params
    params.require(:organization).permit(:name, :website, :owner_id)
  end

  def find_organization(key=:id)
    @organization = Organization.friendly.find(params[key])
  end

  def find_organizations
    @organizations = Organization.all
  end
end
