# typed: true
class Operator::OrganizationBillingController < Operator::BaseController
  def create
    organization = Organization.friendly.find(params[:organization_id])
    out_of_band = params[:out_of_band]
    token = params[:stripeToken]
    result = UpdateOrganizationBilling.call(organization: organization, stripe_token: token, out_of_band: out_of_band)
    if result.success?
      flash[:success] = "Billing info updated."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(organization_path(organization))
  end
end
