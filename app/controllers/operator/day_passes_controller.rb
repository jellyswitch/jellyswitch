# typed: false
class Operator::DayPassesController < Operator::BaseController
  include DayPassesHelper
  before_action :background_image

  def index
    find_day_passes
    authorize @day_passes
  end

  def new
    @day_pass = DayPass.new
    find_day_pass_type
    authorize @day_pass
    include_stripe
  end

  def create
    authorize DayPass.new

    token = params[:stripeToken]
    out_of_band = pay_by_check_params[:out_of_band]

    result = DayPassInteractorFactory.for(token, current_tenant).call(
      params: day_pass_params,
      user_id: current_user.id,
      token: token,
      operator: current_tenant,
      out_of_band: out_of_band,
      location: current_location
    )
    
    @day_pass = result.day_pass

    if result.success?
      if @day_pass.today?
        flash[:success] = "Welcome to #{current_tenant.name}!"
      else
        flash[:success] = "Thanks! Your day pass will be available on #{short_date(@day_pass.day)}."
      end
      flash.keep
      turbolinks_redirect(home_path)
    else
      flash[:error] = result.message
      turbolinks_redirect(new_day_pass_path)
    end
  rescue => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def show
    find_day_pass
    authorize @day_pass
  end
  
  def code
    authorize DayPass.new
  end

  def redeem_code
    result = Billing::DayPasses::RedeemCode.call(
      code: params[:code],
      operator: current_tenant
    )

    if result.success?
      if result.day_pass_type.free?
        result2 = Billing::DayPasses::RedeemFreeDayPass.call(
          user: current_user,
          token: nil,
          day_pass: nil,
          out_of_band: current_user.out_of_band,
          user_id: current_user.id,
          operator: current_tenant,
          params: {
            day: Time.current,
            day_pass_type: result.day_pass_type.id
          }
        )
        if result2.success?
          flash[:success] = "Day Pass redeemed!"
          turbolinks_redirect(home_path, action: "replace")
        else
          flash[:error] = result.message
          turbolinks_redirect(code_day_passes_path, action: "replace")
        end
      else
        turbolinks_redirect(redeem_paid_day_passes_path(code: params[:code], day_pass_type_id: result.day_pass_type_id ))
      end
    else
      flash[:error] = result.message
      turbolinks_redirect(code_day_passes_path, action: "replace")
    end
  end

  def redeem_paid
    result = Billing::DayPasses::RedeemCode.call(
      code: params[:code],
      operator: current_tenant
    )

    if result.success?
      @day_pass_type = result.day_pass_type
      @day_pass = DayPass.new
      include_stripe
    else
      flash[:error] = "No such code."
      turbolinks_redirect(code_day_passes_path, action: "replace")
    end
  end

  private

  def find_day_passes
    @day_passes = DayPass.order('created_at DESC')
  end

  def find_day_pass(key=:id)
    @day_pass = DayPass.find(params[:id])
  end

  def day_pass_params
    params.require(:day_pass).permit(:day, :day_pass_type)
  end

  def find_day_pass_type(key=:day_pass_type_id)
    @day_pass_type = current_tenant.day_pass_types.find(params[key])
  end
end
