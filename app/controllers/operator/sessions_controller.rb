# typed: false
class Operator::SessionsController < Operator::BaseController
  before_action :background_image

  def new
    authorize :session, :new?
  end

  def create
    authorize :session, :create?

    result = Authenticate.call(
      email: params[:session][:email].downcase,
      operator: current_tenant,
      password: params[:session][:password]
    )

    if result.success?
      log_in(result.user)
      remember(result.user)
      turbolinks_redirect(landing_path, action: "restore")
    else
      flash[:error] = result.message
      turbolinks_redirect(login_path, action: "replace")
    end
  end

  def destroy
    log_out
    turbolinks_redirect(root_path, action: "restore")
  end
end
