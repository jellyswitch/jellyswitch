# typed: true
class Checkins::SaveCheckout
  include Interactor

  delegate :checkin, :datetime_out, to: :context

  def call
    if datetime_out.present?
      timestamp = datetime_out
    else
      timestamp = checkin.auto_checkout_time
    end

    if !checkin.update(datetime_out: timestamp)
      context.fail!(message: "Could not check out.")
    end
  end

  def rollback
    checkin.update(datetime_out: nil)
  end
end