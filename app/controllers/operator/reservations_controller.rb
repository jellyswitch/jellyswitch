# typed: false
class Operator::ReservationsController < Operator::BaseController
  before_action :background_image
  include ReservationHelper
  include CreditHelper

  def show
    find_reservation
    authorize @reservation
    background_image
  end

  def choose_day
    @room = current_tenant.rooms.find(params[:room_id])
  end

  def choose_time_post
    @room = current_tenant.rooms.find(params[:room_id])
    if params[:day].present?
      @day = Date.parse(params[:day])
    else
      @day = Date.new(params["day(1i)"].to_i, params["day(2i)"].to_i, params["day(3i)"].to_i)
    end
    turbolinks_redirect choose_time_reservations_path(room_id: @room.id, day: @day)
  end

  def choose_time
    # requires room, day
    @room = current_tenant.rooms.find(params[:room_id])
    if params[:day].present?
      @day = Date.parse(params[:day])
    else
      @day = Date.new(params["day(1i)"].to_i, params["day(2i)"].to_i, params["day(3i)"].to_i)
    end
  end

  def choose_duration
    # require room, day, time
    @room = current_tenant.rooms.find(params[:room_id])
    @day = Date.parse(params[:day])
    @hour = Time.strptime(params[:hour], "%l:%M%P")

    parse_time
  end

  def confirm
    # requires room, day, time, duration
    @room = current_tenant.rooms.find(params[:room_id])
    @day = Date.parse(params[:day])
    @hour = Time.strptime(params[:hour], "%l:%M%P")
    @duration = params[:duration].to_i

    parse_time
    if current_user.should_charge_for_reservation?(current_location) || !current_user.has_billing?
      include_stripe
    end
  end

  def update_billing_and_create_reservation
    @room = current_tenant.rooms.find(params[:room_id])
    @day = Date.parse(params[:day])
    @hour = Time.strptime(params[:hour], "%l:%M%P")
    @duration = params[:duration].to_i

    parse_time

    token = params[:stripeToken]

    result = Billing::Reservations::UpdateBillingAndCreateRoomReservation.call(reservation_params: {
      datetime_in: @datetime_in,
      hours: @duration,
      minutes: @duration.to_i,
      room: @room
    }, user: current_user,
    token: token,
    out_of_band: false)
    @reservation = result.reservation

    if result.success?
      flash[:notice] = "Reserved #{@reservation.room.name} for #{@reservation.pretty_datetime}"
      if current_user.approved?
        turbolinks_redirect(reservation_path(@reservation), action: "restore")
      else
        turbolinks_redirect(wait_path, action: "restore")
      end
    else
      flash[:error] = result.message
      if current_user.approved?
        turbolinks_redirect(confirm_reservations_path(room_id: @room.id, day: @day, hour: pretty_time(@hour), duration: @duration), action: "replace")
      else
        turbolinks_redirect(wait_path, action: "restore")
      end
    end

  end

  def create_reservation
    @room = current_tenant.rooms.find(params[:room_id])
    @day = Date.parse(params[:day])
    @hour = Time.strptime(params[:hour], "%l:%M%P")
    @duration = params[:duration].to_i

    parse_time
    
    result = Billing::Reservations::CreateRoomReservation.call(reservation_params: {
      datetime_in: @datetime_in,
      hours: @duration,
      minutes: @duration.to_i,
      room: @room
    }, user: current_user)
    
    @reservation = result.reservation
    
    if result.success?
      flash[:notice] = "Reserved #{@reservation.room.name} for #{@reservation.pretty_datetime}"
      turbolinks_redirect(reservation_path(@reservation), action: "restore")
    else
      flash[:error] = result.message
      turbolinks_redirect(confirm_reservations_path(room_id: @room.id, day: @day, hour: pretty_time(@hour), duration: @duration), action: "replace")
    end
  end

  def destroy
    find_reservation
    authorize @reservation

    result = CancelReservation.call(reservation: @reservation)

    if result.success?
      flash[:notice] = "Reservation cancelled."
      turbolinks_redirect(root_path)
    else
      flash[:error] = result.message
      turbolinks_redirect(referrer_or_root)
    end
  rescue Exception => e
    Rollbar.error(e)
    flash[:error] = "An error occurred: #{e.message}"
    turbolinks_redirect(referrer_or_root)
  end

  def today
    authorize Reservation
    @rooms = find_todays_reservations(current_tenant)
  end

  private

  def find_reservation(key=:id)
    @reservation = Reservation.find(params[key]).decorate
  end

  def reservation_params
    params.require(:reservation).permit(:room_id, :datetime_in, :hours)
  end

  def flatten_date_array hash
    %w(1 2 3).map { |e| hash["date(#{e}i)"].to_i }
  end

  def parse_time
    zone = ActiveSupport::TimeZone[@room.location.time_zone]
    offset = zone.now.formatted_offset
    time_input = "#{short_date(@day)} #{pretty_time(@hour)} #{offset}"
    @datetime_in = Time.strptime(time_input, "%m/%d/%Y %l:%M%P %Z")
  end
end