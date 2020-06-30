class Billing::Childcare::CreditAccount
  include Interactor

  delegate :amount, :user, :location, to: :context

  def call
    new_amount = user.childcare_reservation_balance + amount
    user.update(childcare_reservation_balance: new_amount)
  end
end