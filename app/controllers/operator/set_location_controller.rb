# typed: true
class Operator::SetLocationController < Operator::BaseController
  before_action :background_image
  include SessionsHelper

  def edit
  end

  def update
    location = Location.find(location_params[:id])
    checkout
    unset_location
    set_location(location)
    
    turbolinks_redirect(root_path)
  rescue ActiveRecord::RecordNotFound => e
    Rollbar.error(e)
    flash[:error] = 'There was a problem finding that location.'
    turbolinks_redirect(root_path)
  end

  private

  def location_params
    params.require(:location).permit(:id)
  end
end
