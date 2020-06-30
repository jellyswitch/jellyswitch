class Operator::ChildcareReservationPurchasesController < Operator::BaseController
  before_action :background_image

  def new
    authorize :childcare_reservation, :new?
  end

  def create
    authorize :childcare_reservation, :create?
    
    @amount = params[:amount].to_i

    result = Billing::Childcare::PurchaseReservations.call(
      location: current_location,
      amount: @amount,
      user: current_user
    )

    if result.success?
      flash[:success] = "Your account balance has been credited with #{@amount} childcare reservations."
      turbolinks_redirect(home_path, action: "replace")
    else
      flash[:error] = result.message
      turbolinks_redirect(new_childcare_reservation_purchase_path, action: "replace")
    end
  end

  def confirm
    @amount = params[:amount].to_i
  end
end