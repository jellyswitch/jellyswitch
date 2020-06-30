class Operator::OnboardingController < Operator::BaseController
  before_action :background_image
  before_action :authorize_onboarding
  include ErrorsHelper
  include PlansHelper
  include DayPassTypesHelper
  include RoomsHelper
  include UsersHelper

  def new
  end

  def new_membership_plan
    @plan = current_tenant.plans.new
  end

  def create_membership_plan
    @plan = Plan.new(plan_params)

    result = Billing::Plans::CreatePlan.call(
      plan: @plan,
      operator: current_tenant,
    )

    if result.success?
      if params[:add_plan_and_add_another].present?
        turbolinks_redirect(new_membership_plan_operator_onboarding_index_path, action: "replace")
      else
        turbolinks_redirect(feed_items_path, action: "replace")
      end
    else
      render :new_membership_plan
    end
  end

  def new_day_pass_type
    @day_pass_type = current_tenant.day_pass_types.new
  end

  def create_day_pass_type
    result = CreateDayPassType.call(params: day_pass_type_params)

    @day_pass_type = result.day_pass_type

    if result.success?
      if params[:add_day_pass_type_and_add_another].present?
        turbolinks_redirect(new_day_pass_type_operator_onboarding_index_path, action: "replace")
      else
        turbolinks_redirect(feed_items_path, action: "replace")
      end
    else
      flash[:error] = result.message
      render :new_day_pass_type, status: 422
    end
  end

  def new_room
    @room = current_location.rooms.new
  end

  def create_room
    @room = Room.new(room_params)

    if @room.save
      flash[:success] = "Room added."
      if params[:add_room_and_add_another].present?
        turbolinks_redirect(new_room_operator_onboarding_index_path, action: "replace")
      else
        turbolinks_redirect(feed_items_path, action: "replace")
      end
    else
      render :new_room, status: 422
    end
  end

  def add_members
  end

  def new_member
    @user = current_tenant.users.new
  end

  def create_member
    result = Users::Create.call(params: user_params, operator: current_tenant)

    if result.success?
      flash[:success] = "Member #{result.user.name} added."
      if params[:add_member_and_create_another].present?
        turbolinks_redirect(new_member_operator_onboarding_index_path, action: "replace")
      else
        turbolinks_redirect(feed_items_path, action: "replace")
      end
    else
      flash[:error] = result.message
      render :new_member, status: 422
    end
  end

  def new_stripe_members
    result = Onboarding::FetchStripeCustomers.call(operator: current_tenant)

    if result.success?
      @customers = result.customers
    else
      flash[:error] = result.message
      turbolinks_redirect(add_members_operator_onboarding_index_path, action: "replace")
    end
  end

  def create_stripe_members
    user = current_tenant.users.new(
      name: params[:name],
      email: params[:email],
      stripe_customer_id: params[:stripe_customer_id],
      card_added: params[:card_added] == "true",
      password: "pizza123",
      approved: true
    )

    if user.save
      flash[:success] = "Member added."
    else
      flash[:error] = errors_for(user)
    end

    turbolinks_redirect(new_stripe_members_operator_onboarding_index_path, action: "replace")
  end

  def new_kisi
    if current_tenant.kisi_api_key.present?
      turbolinks_redirect(new_door_operator_onboarding_index_path, action: "replace")
    end
  end

  def create_kisi
    api_key = params[:kisi_api_key]
    if api_key.blank?
      flash[:error] = "Please enter an API key below."
      render :new_kisi
    else
      current_tenant.update(kisi_api_key: api_key)
      turbolinks_redirect(new_door_operator_onboarding_index_path)
    end
  end

  def new_door
    result = Onboarding::GetKisiDoors.call(operator: current_tenant)

    if result.success?
      @doors = result.doors
    else
      @doors = []
      flash[:error] = result.message
    end
  end

  def create_door
    door = current_location.doors.new(
      name: params[:door_name],
      kisi_id: params[:kisi_id],
    )

    if door.save
      flash[:success] = "Door added."
    else
      flash[:error] = "There was a problem adding your door."
    end
    turbolinks_redirect(new_door_operator_onboarding_index_path, action: "replace")
  end

  def destroy_door
    door = current_location.doors.find_by(kisi_id: params[:kisi_id])
    if door.present?
      if door.destroy
        flash[:success] = "Door removed."
      else
        flash[:error] = "There was a problem removing that door."
      end
    else
      flash[:error] = "No such door."
    end
    turbolinks_redirect(new_door_operator_onboarding_index_path, action: "replace")
  end

  def skip
    current_tenant.update(skip_onboarding: true)
    turbolinks_redirect(feed_items_path)
  end

  private

  def authorize_onboarding
    authorize :onboarding, :show?
  end
end
