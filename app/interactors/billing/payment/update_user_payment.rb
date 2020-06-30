# typed: true
class Billing::Payment::UpdateUserPayment
  include Interactor

  delegate :user, :token, :out_of_band, to: :context

  def call
    if out_of_band
      user.update(out_of_band: true)
    else
      if token
        if user.operator.create_or_update_customer_payment(user, token)
          user.update(card_added: true)
        else
          context.fail!(message: "Cannot update payment method.")
        end
      else
        context.fail!(message: "Cannot update payment method with null token.")
      end
    end
  end
end
