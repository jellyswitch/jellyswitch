# typed: true
class Billing::Payment::SetToCreditCard
  include Interactor

  delegate :user, to: :context

  def call
    if user.card_added?
      if !user.update(out_of_band: false, bill_to_organization: false)
        context.fail!(message: "An error occurred.")
      end
    else
      context.fail!(message: "User has no card on file.")
    end
  end
end
