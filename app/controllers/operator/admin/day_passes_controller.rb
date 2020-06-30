# typed: false
class Operator::Admin::DayPassesController < Operator::BaseController
  include DayPassesHelper

  def new
    authorize DayPass.new
    @user = current_tenant.users.find(params[:user_id])
  end

  def create
    authorize DayPass.new

    user = User.find(day_pass_params[:user_id])
    token = params[:stripeToken]
    out_of_band = pay_by_check_params[:out_of_band]

    result = DayPassInteractorFactory.for(token, current_tenant).call(
      params: day_pass_params,
      user_id: user.id,
      token: token,
      operator: current_tenant,
      out_of_band: out_of_band,
      location: current_location
    )

    @day_pass = result.day_pass

    if result.success?
      flash[:success] = "Day pass added."
      turbolinks_redirect(user_path(@day_pass.user), action: "replace")
    else
      flash[:error] = result.message
      turbolinks_redirect(user_path(user))
    end
  rescue => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  private
  
  def day_pass_params
    params.require(:day_pass).permit(:day_pass_type, :day, :user_id)
  end
end