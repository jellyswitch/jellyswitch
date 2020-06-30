class Users::AddCredits
  include Interactor

  delegate :user, :amount, to: :context

  def call
    new_balance = user.credit_balance + amount
    if !user.update(credit_balance: new_balance)
      context.fail!(message: "Couldn't update credit balance.")
    end
  end
end