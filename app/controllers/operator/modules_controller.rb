class Operator::ModulesController < Operator::BaseController
  before_action :background_image
  before_action { authorize :module }

  def index
  end

  def announcements
    setting(:announcements_enabled)
  end

  def bulletin_board
    setting(:bulletin_board_enabled)
  end

  def events
    setting(:events_enabled)
  end

  def door_integration
    setting(:door_integration_enabled)
  end

  def rooms
    setting(:rooms_enabled)
  end

  def credits
    setting(:credits_enabled)
  end

  def crm
    setting(:crm_enabled)
  end

  def offices
    if current_tenant.has_active_office_leases?
      flash[:error] = "Terminate active office leases before disabling."
      turbolinks_redirect(modules_path, action: "replace")
    else
      setting(:offices_enabled)
    end
  end

  def childcare
    setting(:childcare_enabled)
  end
  
  def reservation_credits_settings
    location = current_tenant.locations.find(params[:location_id])

    dollars = Money.from_amount(params[:credit_cost].to_i, "USD")
    amount_in_cents = dollars.cents


    if !location.update(credit_cost_in_cents: amount_in_cents)
      flash[:error] = "Something went wrong."
    end
    turbolinks_redirect(modules_path, action: "replace")
  end

  def childcare_reservations_settings
    location = current_tenant.locations.find(params[:location_id])

    dollars = Money.from_amount(params[:childcare_reservation_cost].to_i, "USD")
    amount_in_cents = dollars.cents

    if !location.update(childcare_reservation_cost_in_cents: amount_in_cents)
      flash[:error] = "Something went wrong."
    end
    turbolinks_redirect(modules_path, action: "replace")
  end

  private

  def setting(symbol)
    result = ToggleValue.call(object: current_tenant, value: symbol)
    
    if !result.success?
      flash[:error] = result.message
    end

    turbolinks_redirect(modules_path, action: "replace")
  end
end