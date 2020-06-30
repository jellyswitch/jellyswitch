# typed: false
class UsersController < ApplicationController
  def index
    find_approved_users
    authorize @users
    background_image
  end

  def unapproved
    find_unapproved_users
    authorize @users
    background_image
  end

  def show
    find_user
    authorize @user
    background_image

    if @user == current_user
      render :show
    else
      render :profile
    end
  end

  def new
    @user = User.new
    authorize @user

    if logged_in? && !admin?
      # this is a normal user creating another user
      flash[:success] = "Please log out first."
      redirect_to root_path
    end
  end

  def edit
    find_user
    authorize @user
    background_image
  end

  def create
    # Create the admin user
    # Create the operator instance
    # Redirect them to the operator instance

    @user = User.new(user_params)

    if @user.save
      log_in(@user)

      if !result.success?
        flash[:error] = result.message
        # TODO? what to do here?
        redirect_to root_path(subdomain: "app")
      else
        @user.update(operator_id: result.operator.id)
        redirect_to new_operator_survey_path
      end
    else
      background_image
      render :new, status: 422
    end
  end

  def update
    find_user
    authorize @user

    @user.update_attributes(user_params)

    if @user.save
      flash[:success] = "Your profile has been updated."
      redirect_to user_path(@user)
    else
      render :edit, status: 422
    end
  end

  def change_password
    find_user(:user_id)
    authorize @user
  end

  def update_password
    find_user(:user_id)
    authorize @user

    @user.update_attributes(user_password_params)

    if @user.save
      flash[:success] = "Your password has been changed."
      redirect_to user_path(@user)
    else
      render :change_password, status: 422
    end
  end

  def update_organization
    find_user(:user_id)
    authorize @user

    @user.update_attributes(user_organization_params)

    if @user.save
      flash[:success] = "Updated organization."
      redirect_to user_path(@user)
    else
      render :show, status: 422
    end
  end

  def memberships
    find_user(:user_id)
    authorize @user
    background_image
  end

  def day_passes
    find_user(:user_id)
    authorize @user
    background_image
  end

  def reservations
    find_user(:user_id)
    authorize @user

    @reservations = @user.reservations.order("created_at DESC").all.decorate
    background_image
  end

  def invoices
    find_user(:user_id)
    authorize @user

    @invoices = @user.invoices
    background_image
  end

  def approve
    find_user(:user_id)
    @user.update_attributes(user_approval_params)
    if @user.save
      flash[:success] = "User approved."
    else
      flash[:error] = "Couldn't approve user."
    end
    redirect_to user_path(@user)
  end

  def unapprove
    find_user(:user_id)
    @user.update_attributes(user_approval_params)
    if @user.save
      flash[:success] = "User unapproved."
    else
      flash[:error] = "Couldn't unapprove user."
    end
    redirect_to user_path(@user)
  end

  def edit_billing
    find_user(:user_id)
    background_image
    include_stripe
  end

  def update_billing
    find_user(:user_id)
    token = params[:stripeToken]
    result = Billing::Payment::UpdateUserPayment.call(user: current_user, token: token)
    if result.success?
      flash[:success] = "Billing info updated."
      redirect_to user_path(current_user)
    else
      flash[:error] = result.message
      redirect_to user_billing_path(current_user)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end

  def find_user(key = :id)
    @user = User.friendly.find(params[key])
  end

  def find_approved_users
    @users = User.approved
  end

  def find_unapproved_users
    @users = User.unapproved
  end
end
