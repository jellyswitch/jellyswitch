class Billing::Reservations::ChargeCredits
  include Interactor
  include CreditHelper

  delegate :reservation, :reservation_params, :user, to: :context

  def call
    if user.operator.credits_enabled?
      if !user.admin?
        @existing_balance = user.credit_balance

        @charge_amount = reservation_cost(reservation_params[:room], reservation_params[:minutes])

        if user.credit_balance < @charge_amount
          context.fail!(message: "Insufficient credit balance.")
        end

        if !user.update(credit_balance: ending_balance(user, @charge_amount))
          context.fail!(message: "Unable to set user credit balance.")
        end

        if !reservation.update(credit_cost: @charge_amount)
          context.fail!(message: "Unable to record credit cost on reservation.")
        end
      end
    end
  end

  def rollback
    if user.operator.credits_enabled?
      if !user.admin?
        user.update(credit_balance: @existing_balance)
        reservation.update(credit_cost: 0)
      end
    end
  end
end