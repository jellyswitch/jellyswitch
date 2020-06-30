# typed: false
class Operator::PasswordResetsController < Operator::BaseController
  before_action :background_image

  def new
  end

  def create
    @user = User.find_by_operator(email: params[:password_reset][:email].downcase, operator_id: current_tenant.id)

    if @user
      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:success] = "Email sent with password reset instructions"
      turbolinks_redirect(root_path, action: "replace")
    else
      flash[:error] = "Email address not found."
      turbolinks_redirect(new_password_reset_path, action: "replace")
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def edit
    find_user
    check_expiration
  end

  def update
    find_user
    check_expiration

    if params[:user][:password].empty?                  # Case (3)
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update_attributes(user_params)          # Case (4)
      log_in @user
      flash[:success] = "Password has been reset."
      turbolinks_redirect(root_path, action: "replace")
    else
      render 'edit'                                     # Case (2)
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  private

  def find_user
    @user = User.find_by_operator(email: params[:email].downcase, operator_id: current_tenant.id)
  end

  def check_expiration
    if @user.password_reset_expired?
      flash[:error] = "Password reset has expired."
      turbolinks_redirect(new_password_reset_url, action: "replace")
    end
  end

  def user_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end