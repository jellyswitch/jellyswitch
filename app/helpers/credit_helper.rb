module CreditHelper
  def reservation_cost(room, duration)
    (room.credit_cost / 60.0) * duration
  end

  def ending_balance(user, amount)
    user.credit_balance - amount
  end
end