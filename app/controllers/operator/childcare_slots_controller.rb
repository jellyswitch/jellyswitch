class Operator::ChildcareSlotsController < Operator::BaseController
  before_action :background_image

  def index
    find_childcare_slots
    authorize @childcare_slots
  end

  def new
    @childcare_slot = current_location.childcare_slots.new
    authorize @childcare_slot
  end

  def create
    @childcare_slot = current_location.childcare_slots.new(childcare_slot_params)

    if @childcare_slot.save
      turbolinks_redirect(childcare_slots_path, action: "replace")
    else
      flash[:error] = "Something went wrong."
      turbolinks_redirect(new_childcare_slot_path, action: "replace")
    end
  end

  def show
    find_childcare_slot
    authorize @childcare_slot
  end

  def edit
    find_childcare_slot
    authorize @childcare_slot
  end

  def update
    find_childcare_slot
    authorize @childcare_slot

    if @childcare_slot.update(childcare_slot_params)
      flash[:success] = "Availability updated."
      turbolinks_redirect(childcare_slot_path(@childcare_slot), action: "replace")
    else
      flash[:error] = "Something went wrong."
      turbolinks_redirect(edit_childcare_slot_path(@childcare_slot), action: "replace")
    end
  end

  def destroy
    find_childcare_slot
    authorize @childcare_slot

    if @childcare_slot.update(deleted: true)
      turbolinks_redirect(childcare_slots_path, action: "replace")
    else
      flash[:error] = "Something went wrong."
      turbolinks_redirect(childcare_slot_path(@childcare_slot), action: "replace")
    end
  end

  private

  def find_childcare_slots
    @childcare_slots = current_location.childcare_slots.visible.order(:week_day)
  end

  def find_childcare_slot(key=:id)
    @childcare_slot = current_location.childcare_slots.find(params[key])
  end

  def childcare_slot_params
    params.require(:childcare_slot).permit(:name, :week_day, :location_id, :capacity)
  end

end