class Operator::CreditPurchasesController < Operator::BaseController
  before_action :background_image

  def new
    authorize :credit, :new?
  end

  def create
    authorize :credit, :create?
    
    @amount = params[:amount].to_i

    result = Billing::Credits::PurchaseCredits.call(
      location: current_location,
      amount: @amount,
      user: current_user
    )

    if result.success?
      flash[:success] = "Your account has been credited with #{@amount} credits."
      turbolinks_redirect(home_path, action: "replace")
    else
      flash[:error] = result.message
      turbolinks_redirect(new_credit_purchase_path, action: "replace")
    end
  end

  def confirm
    authorize :credit, :confirm?
    @amount = params[:amount].to_i
  end
end