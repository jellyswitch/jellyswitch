class Operator::DoorPunchesController < Operator::BaseController
  before_action :background_image

  def show
    @door_punch = DoorPunch.find(params[:id])
    authorize @door_punch
  end
end