# typed: false
class Operator::PlansController < Operator::BaseController
  include PlansHelper
  before_action :background_image

  def index
    find_plans
    authorize @plans
  end

  def archived
    find_plans
    authorize @plans
  end

  def new
    @plan = Plan.new
    authorize @plan
  end

  def create
    @plan = Plan.new(plan_params)
    authorize @plan

    result = Billing::Plans::CreatePlan.call(
      plan: @plan,
      operator: current_tenant
    )

    if result.success?
      flash[:notice] = "Plan saved."
      if params[:add_plan_and_add_another].present?
        turbolinks_redirect(new_plan_path, action: "replace")
      else
        turbolinks_redirect(plan_path(@plan))
      end
    else
      flash[:error] = result.message
      turbolinks_redirect(new_plan_path)
    end
  end

  def show
    find_plan
    authorize @plan
  end

  def edit
    find_plan
    authorize @plan
  end

  def update
    find_plan
    authorize @plan

    if @plan.update(plan_update_params)
      flash[:notice] = "Plan updated."
      turbolinks_redirect(plan_path(@plan))
    else
      render :edit, status: 422
    end
  end

  def destroy
    find_plan
    authorize @plan

    @plan.update_attributes({available: false})
    if @plan.save
      flash[:notice] = "Plan archived."
      turbolinks_redirect(plans_path)
    else
      flash[:error] = "Unable to archive plan: #{@plan.name}"
      turbolinks_redirect(referrer_or_root)
    end
  rescue => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def unarchive
    find_plan(:plan_id)
    authorize @plan
    result = UnarchivePlan.call(plan: @plan)
    if result.success?
      flash[:success] = "Plan unarchived."
    else
      flash[:error] = result.message
    end
    turbolinks_redirect(plans_path, action: "advance")
  rescue => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def toggle_visibility
    find_plan(:plan_id)
    authorize @plan
    
    result = ToggleValue.call(object: @plan, value: :visible)
    
    if !result.success?
      flash[:error] = result.message
    end
    turbolinks_redirect(plan_path(@plan), action: "replace")
  end

  def toggle_availability
    find_plan(:plan_id)
    authorize @plan
    
    result = ToggleValue.call(object: @plan, value: :available)
    
    if !result.success?
      flash[:error] = result.message
    end
    turbolinks_redirect(plan_path(@plan), action: "replace")
  end

  def toggle_building_access
    find_plan(:plan_id)
    authorize @plan
    
    result = ToggleValue.call(object: @plan, value: :always_allow_building_access)
    
    if !result.success?
      flash[:error] = result.message
    end
    turbolinks_redirect(plan_path(@plan), action: "replace")
  end

  private

  def find_plans
    @plans = Plan.individual.order(:name)
  end

  def find_plan(key=:id)
    @plan = Plan.friendly.find(params[key])
  end

  def plan_update_params
    params.require(:plan).permit(:visible, 
      :available, :always_allow_building_access, 
      :credits, :description, :childcare_reservations, 
      location_ids: [])
  end
end
