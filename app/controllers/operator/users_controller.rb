# typed: false
class Operator::UsersController < Operator::BaseController
  include UsersHelper
  before_action :background_image
  
  def index
    find_approved_users
    @unapproved_users = User.for_space(current_tenant).unapproved.visible.order("name")
    @archived_users = User.for_space(current_tenant).archived.order("name")
    authorize @users
  end

  def unapproved
    find_unapproved_users
    authorize @users
  end

  def archived
    find_archived_users
    authorize @users
  end

  def show
    find_user
    authorize @user

    @usage_report = Jellyswitch::UsageReport.new(@user)

    if @user == current_user
      render :show
    else
      render :profile
    end
  end

  def about
    find_user(:user_id)
    authorize @user
  end

  def ltv
    find_user(:user_id)
    authorize @user

    @months = (Time.current.year * 12 + Time.current.month) - (@user.created_at.year * 12 + @user.created_at.month)
  end

  def usage
    find_user(:user_id)
    authorize @user
    @usage_report = Jellyswitch::UsageReport.new(@user)
  end

  def payment_method
    find_user(:user_id)
    authorize @user
  end

  def membership
    find_user(:user_id)
    authorize @user
  end

  def admin_day_passes
    find_user(:user_id)
    authorize @user
  end

  def checkins
    find_user(:user_id)
    authorize @user
  end

  def organization
    find_user(:user_id)
    authorize @user
  end

  def admin_invoices
    find_user(:user_id)
    authorize @user
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

  def add_member
    @user = User.new
    @user.approved = true
    authorize @user
  end

  def edit
    find_user
    authorize @user
  end

  def create
    authorize User.new
    result = Users::Create.call(params: user_params, operator: current_tenant)

    if result.success?
      if admin? # admin is creating the user
        flash[:success] = "Member #{result.user.name} added."
        if params[:add_member_and_create_another].present?
          turbolinks_redirect(add_member_users_path, action: "replace")
        else
          turbolinks_redirect(user_path(result.user), action: "replace")
        end
      else
        log_in(result.user)

        if current_location.new_users_get_free_day_pass?
          # todo: fold this into two interactors: one that creates a user and one that creates a user and provisoins a new day pass
          # provision new free day pass
          day_pass_result = Billing::DayPasses::CreateFreeDayPass.call(
            user: current_user,
            location: current_location,
          )

          if day_pass_result.success?
            flash[:success] = "Thanks for signing up! You've been granted a free day pass, pending approval. Enjoy!"
          else
            flash[:error] = day_pass_result.message
          end
        end
        turbolinks_redirect(home_path, action: "replace")
      end
    else
      @user = result.user
      if result.message
        flash[:error] = result.message
      end
      if admin? # Admin is creating a user
        render :add_member, status: 422
      else
        render :new, status: 422
      end
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def update
    find_user
    authorize @user

    @user.update_attributes(user_params)

    if @user.save
      flash[:success] = "Your profile has been updated."
      turbolinks_redirect(user_path(@user))
    else
      render :edit, status: 422
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
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
      turbolinks_redirect(user_path(@user))
    else
      render :change_password, status: 422
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def update_organization
    find_user(:user_id)
    authorize @user

    @user.update_attributes(user_organization_params)

    if @user.save
      flash[:success] = "Updated organization."
      turbolinks_redirect(user_path(@user))
    else
      render :show, status: 422
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def remove_from_organization
    find_user(:user_id)
    authorize @user

    if @user.update(organization_id: nil)
      flash[:success] = "Removed from group."
    else
      flash[:error] = "Unable to remove from group."
    end

    turbolinks_redirect(user_path(@user), action: "replace")
  end

  def set_password_and_send_email
    find_user(:user_id)
    authorize @user

    result = Onboarding::SetPasswordAndSendEmail.call(user: @user)

    if result.success?
      flash[:success] = "Password and onboarding email sent."
    else
      flash[:error] = result.message
    end
    turbolinks_redirect(user_path(@user), action: "replace")
  end

  def memberships
    find_user(:user_id)
    authorize @user
  end

  def day_passes
    find_user(:user_id)
    authorize @user
  end

  def reservations
    find_user(:user_id)
    authorize @user

    find_upcoming_reservations
  end

  def past_reservations
    find_user(:user_id)
    authorize @user

    find_past_reservations
  end

  def invoices
    find_user(:user_id)
    authorize @user

    @invoices = @user.invoices
  end

  def approve
    find_user(:user_id)
    if @user.update(approved: true)
      flash[:success] = "User approved."
    else
      flash[:error] = "Couldn't approve user."
    end
    turbolinks_redirect(approval_redirect_path)
  end

  def unapprove
    find_user(:user_id)
    if @user.update(approved: false)
      flash[:success] = "User unapproved."
    else
      flash[:error] = "Couldn't unapprove user."
    end
    turbolinks_redirect(approval_redirect_path)
  end

  def archive
    find_user(:user_id)
    authorize @user

    if @user.member_at_operator?(current_tenant)
      flash[:error] = "Cannot archive an active member."
    else
      if @user.update(archived: true, approved: false)
        flash[:success] = "User archived (and unapproved)."
      else
        flash[:error] = "Couldn't archive user."
      end
    end
    turbolinks_redirect(user_path(@user))
  end

  def unarchive
    find_user(:user_id)
    authorize @user
    if @user.update(archived: false, approved: true)
      flash[:success] = "User unarchived."
    else
      flash[:error] = "Couldn't unarchive user."
    end
    turbolinks_redirect(user_path(@user))
  end

  def edit_billing
    find_user(:user_id)
    include_stripe
  end

  def update_billing
    find_user(:user_id)
    token = params[:stripeToken]
    result = Billing::Payment::UpdateUserPayment.call(user: current_user, token: token)
    if result.success?
      flash[:success] = "Billing info updated."
      turbolinks_redirect(user_path(current_user))
    else
      flash[:error] = result.message
      turbolinks_redirect(user_billing_path(current_user))
    end
  end

  def update_payment_method
    find_user(:user_id)

    if payment_method_params[:out_of_band] == "1"
      result = MarkCustomerAsOutOfBand.call(user: @user)
    else
      result = UnmarkCustomerAsOutOfBand.call(user: @user)
    end

    if result.success?
      flash[:success] = "Payment method updated."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(user_path(@user))
  end

  def credit_card
    find_user(:user_id)
    result = Billing::Payment::SetToCreditCard.call(user: @user)

    if result.success?
      flash[:success] = "Payment method updated."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(user_path(@user), action: "replace")
  end

  def credits
    find_user(:user_id)
    authorize @user
  end

  def childcare
    find_user(:user_id)
    authorize @user
  end

  def add_credits
    find_user(:user_id)
    authorize @user

    result = Users::AddCredits.call(
      user: @user,
      amount: params[:amount].to_i
    )

    if result.success?
      flash[:success] = "Credits added."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(user_credits_path(@user), action: "replace")
  end

  def add_childcare_reservations
    find_user(:user_id)
    authorize @user

    result = Users::AddChildcareReservations.call(
      user: @user,
      amount: params[:amount].to_i
    )

    if result.success?
      flash[:success] = "Balance added."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(user_childcare_path(@user), action: "replace")
  end

  def out_of_band
    find_user(:user_id)
    result = Billing::Payment::SetToOutOfBand.call(user: @user)

    if result.success?
      flash[:success] = "Payment method updated."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(user_path(@user), action: "replace")
  end

  def bill_to_organization
    find_user(:user_id)
    result = Billing::Payment::SetToBillOrganization.call(user: @user)

    if result.success?
      flash[:success] = "Payment method updated."
    else
      flash[:error] = result.message
    end

    turbolinks_redirect(user_path(@user), action: "replace")
  end

  private

  def user_password_params
    params.require(:user).permit(:password, :password_confirmation)
  end

  def user_organization_params
    params.require(:user).permit(:organization_id)
  end

  def payment_method_params
    params.require(:user).permit(:out_of_band)
  end

  def find_upcoming_reservations
    @reservations = @user.reservations.future.order("datetime_in ASC").limit(100).group_by_day(&:datetime_in)
    @reservations.keys.each do |key|
      @reservations[key] = @reservations[key].map(&:decorate)
    end
  end

  def find_past_reservations
    @reservations = @user.reservations.past.order("datetime_in ASC").limit(100).group_by_day(reverse: true) {|r| r.datetime_in }
    @reservations.keys.each do |key|
      @reservations[key] = @reservations[key].map(&:decorate)
    end

  end
end
