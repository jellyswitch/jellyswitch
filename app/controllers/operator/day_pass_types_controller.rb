# typed: true
class Operator::DayPassTypesController < Operator::BaseController
  include DayPassTypesHelper
  before_action :find_day_pass_type, only: [:show, :edit, :update, :destroy]
  before_action :background_image

  def index
    find_day_pass_types
    authorize @day_pass_types
  end

  def show
    authorize @day_pass_type
  end

  def new
    @day_pass_type = DayPassType.new
    authorize @day_pass_type
  end

  def edit
    authorize @day_pass_type
  end

  def create
    authorize DayPassType.new
    result = CreateDayPassType.call(params: day_pass_type_params)

    @day_pass_type = result.day_pass_type
    if result.success?
      if params[:add_day_pass_type_and_add_another].present?
        turbolinks_redirect(new_day_pass_type_path, action: "replace")
      else
        turbolinks_redirect(day_pass_type_path(@day_pass_type))
      end
    else
      flash[:error] = result.message
      render :new, status: 422
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def update
    authorize @day_pass_type

    if @day_pass_type.update(day_pass_type_update_params)
      flash[:success] = "Day pass type was successfully updated."
      turbolinks_redirect(day_pass_type_path(@day_pass_type))
    else
      render :edit, status: 422
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def destroy
    authorize @day_pass_type
    @day_pass_type.update(available: false)
    flash[:success] = "Day pass type was successfully archived."
    turbolinks_redirect(day_pass_types_url)
  end

  def visible
    setting(:visible)
  end

  def always_allow_building_access
    setting(:always_allow_building_access)
  end

  def available
    setting(:available)
  end

  private

  def find_day_pass_type(key = :id)
    @day_pass_type = DayPassType.find(params[key])
  end

  def find_day_pass_types
    @day_pass_types = DayPassType.all
  end

  def setting(symbol)
    find_day_pass_type(:day_pass_type_id)
    result = ToggleValue.call(object: @day_pass_type, value: symbol)
    
    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(day_pass_type_path(@day_pass_type), action: "replace")
  end
end
