class Billing::Credits::CreditAccount
  include Interactor

  delegate :amount, :user, :location, to: :context

  def call
    new_amount = user.credit_balance + amount
    user.update(credit_balance: new_amount)
  end
end