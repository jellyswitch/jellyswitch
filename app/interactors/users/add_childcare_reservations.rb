class Users::AddChildcareReservations
  include Interactor

  delegate :user, :amount, to: :context

  def call
    new_balance = user.childcare_reservation_balance + amount
    if !user.update(childcare_reservation_balance: new_balance)
      context.fail!(message: "Couldn't update balance.")
    end
  end
end