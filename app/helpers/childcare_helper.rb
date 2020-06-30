module ChildcareHelper
  def ending_balance(user, amount)
    user.childcare_reservation_balance - amount
  end

  def class_for_childcare_button(user)
    user.childcare_reservation_balance < 1 ? "disabled" : ""
  end
end