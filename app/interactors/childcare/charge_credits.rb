class Childcare::ChargeCredits
  include Interactor
  include ChildcareHelper

  delegate :operator, :child_profile, :childcare_slot, :date, to: :context

  def call
    if operator.childcare_enabled?
      user = child_profile.user
      
      if !user.admin?
        @existing_balance = user.childcare_reservation_balance

        if @existing_balance < 1
          context.fail!(message: "Insufficient credit balance.")
        end

        if !user.update(childcare_reservation_balance: ending_balance(user, 1))
          context.fail!(message: "Unable to set user credit balance.")
        end
      end
    end
  end

  def rollback
    user = child_profile.user

    if operator.childcare_enabled?
      if !user.admin?
        user.update(childcare_reservation_balance: user.childcare_reservation_balance + 1)
      end
    end
  end
end