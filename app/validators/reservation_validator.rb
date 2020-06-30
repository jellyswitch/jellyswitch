# typed: true
class ReservationValidator < ActiveModel::Validator
  def validate(record)
    if record.cancelled?
      return true
    end
  end
end