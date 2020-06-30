# typed: false
class Operator::OperatorsController < Operator::BaseController
  before_action :background_image

  def show
    find_operator
    authorize @operator
  end

  def edit
    find_operator
    authorize @operator
  end

  def update
    find_operator

    @operator.update_attributes(operator_params)

    if @operator.save
      flash[:success] = "Operator has been updated."
      redirect_to operator_path(@operator)
    else
      render :edit, status: 422
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def stripe_connect_setup
    find_operator
    if params[:error].present?
      flash[:error] = params[:error_description]
    else
      result = Operators::FinishStripeConnect.call(
        stripe_code: params[:code],
        operator: @operator,
        webhook_url: stripe_webhooks_url
      )

      if result.success?
        flash[:success] = "Your account has been connected to Stripe."
      else
        flash[:error] = "There was a problem storing your Stripe credentials. (#{result.message})"
      end
    end
    redirect_to operator_path(@operator, subdomain: @operator.subdomain)
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def approval_required
    find_operator
    result = ToggleValue.call(object: @operator, value: :approval_required)
    
    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(operator_path(@operator, subdomain: @operator.subdomain), action: "replace")
  end

  def checkin_required
    find_operator
    result = ToggleValue.call(object: @operator, value: :checkin_required)
    
    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(operator_path(@operator, subdomain: @operator.subdomain), action: "replace")
  end

  private

  def find_operator
    @operator = current_tenant
  end

  def operator_params
    params.require(:operator).permit(:name, :snippet, :wifi_name, :wifi_password, :building_address, 
      :approval_required, :contact_name, :contact_email, :contact_phone,
      :background_image, :logo_image, :square_footage, :kisi_api_key, :terms_of_service, :checkin_required,
      :membership_text)
  end
end