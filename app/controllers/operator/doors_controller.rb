# typed: false
class Operator::DoorsController < Operator::BaseController
  def index
    find_doors
    authorize @doors
    background_image
  end

  def show
    find_door
    authorize @door
    @pagy, @punches = pagy(@door.door_punches.order('created_at DESC'))
    background_image
  end

  def new
    @door = Door.new
    authorize @door
    background_image
  end

  def create
    @door = Door.new(door_params)
    authorize @door

    if @door.save
      flash[:notice] = "Door created."
      turbolinks_redirect(door_path(@door))
    else
      background_image
      render :new, status: 422
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def edit
    find_door
    authorize @door
    background_image
  end

  def update
    find_door
    authorize @door

    @door.update_attributes(door_params)
    if @door.save
      flash[:notice] = "Door updated."
      turbolinks_redirect(doors_path(@door))
    else
      background_image
      render :edit, status: 422
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def keys
    find_doors
    authorize @doors
    background_image
  end

  def open
    find_door(:door_id)
    authorize @door
    log_door_punch
    OpenDoorJob.perform_later(@door, current_user)
    response.headers["Turbolinks-Location"] = home_url
    redirect_to home_path
  end

  private

  def find_doors
    @doors = Door.all
  end

  def find_door(key=:id)
    @door = Door.friendly.find(params[key])
  end

  def door_params
    params.require(:door).permit(:name, :kisi_id)
  end

  def log_door_punch
    DoorPunch.create!(user: current_user, door: @door)
  end
end
