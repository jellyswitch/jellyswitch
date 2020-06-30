# typed: false
class Operator::LocationsController < Operator::BaseController
  before_action :find_location, only: [:show, :edit, :update, :destroy]
  before_action :background_image

  def index
    @locations = Location.all
    authorize @locations
  end

  def new
    @location = Location.new
    setup_hours
    authorize @location
  end

  def create
    @location = Location.new(location_params)

    authorize @location

    if @location.save
      flash[:success] = "Location created."
      turbolinks_redirect location_path(@location)
    else
      flash[:error] = "Could not save location."
      render :new
    end
  end

  def show
    authorize @location
  end

  def edit
    setup_hours
    authorize @location
  end

  def update
    authorize @location

    if @location.update(location_params)
      flash[:success] = "Location updated."
      turbolinks_redirect location_path(@location)
    else
      flash[:error] = "Could not update location."
      render :new
    end
  end

  def destroy
    authorize @location

    if @location.destroy
      flash[:success] = "Location removed."
      turbolinks_redirect location_path(@location)
    else
      flash[:error] = "Could not remove location."
      render :new
    end
  end

  def allow_hourly
    find_location(:location_id)
    authorize @location
    result = ToggleValue.call(object: @location, value: :allow_hourly)
    
    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(location_path(@location), action: "replace")
  end

  def new_users_get_free_day_pass
    find_location(:location_id)
    authorize @location
    result = ToggleValue.call(object: @location, value: :new_users_get_free_day_pass)
    
    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(location_path(@location), action: "replace")
  end

  def visible
    find_location(:location_id)
    authorize @location
    result = ToggleValue.call(object: @location, value: :visible)
    
    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(location_path(@location), action: "replace")
  end

  private

  def find_location(key=:id)
    @location = Location.find(params[key])
  end

  def setup_hours
    @hourly_options = [
      ["12:00am", "00:00"],
      ["1:00am", "01:00"],
      ["2:00am", "02:00"],
      ["3:00am", "03:00"],
      ["4:00am", "04:00"],
      ["5:00am", "05:00"],
      ["6:00am", "06:00"],
      ["7:00am", "07:00"],
      ["8:00am", "08:00"],
      ["9:00am", "09:00"],
      ["10:00am", "10:00"],
      ["11:00am", "11:00"],
      ["12:00pm", "12:00"],
      ["1:00pm", "13:00"],
      ["2:00pm", "14:00"],
      ["3:00pm", "15:00"],
      ["4:00pm", "16:00"],
      ["5:00pm", "17:00"],
      ["6:00pm", "18:00"],
      ["7:00pm", "19:00"],
      ["8:00pm", "20:00"],
      ["9:00pm", "21:00"],
      ["10:00pm", "22:00"],
      ["11:00pm", "23:00"],
      ["11:59pm", "23:59"]
    ]
  end

  def location_params
    params.require(:location).permit(
      :name, :snippet, :wifi_name, :wifi_password, :building_address,
      :city, :state, :zip, :contact_name, :contact_email, :contact_phone,
      :background_image, :square_footage, :time_zone, :visible,
      :flex_square_footage, :common_square_footage, :building_access_instructions,
      :allow_hourly, :hourly_rate_in_cents, :new_users_get_free_day_pass,
      :open_sunday, :open_monday, :open_tuesday, :open_wednesday, :open_thursday,
      :open_friday, :open_saturday, :working_day_start, :working_day_end, 
      :credit_cost_in_cents
    )
  end
end
