# typed: true
class Operator::OrganizationMembersController < Operator::BaseController
  def create
    organization = Organization.friendly.find(params[:organization_id])

    organization.users << User.where(id: user_params[:ids])

    if organization.save
      flash[:success] = "Successfully added members."
    else
      flash[:error] = "Could not add members."
    end

    turbolinks_redirect(organization_path(organization))
  end

  private

  def user_params
    params.require(:user).permit(ids: [])
  end
end
