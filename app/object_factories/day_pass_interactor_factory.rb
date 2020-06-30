# typed: true
class DayPassInteractorFactory
  def self.for(token, operator)
    if token.present?
      Billing::DayPasses::UpdatePaymentAndCreateDayPass
    else
      Billing::DayPasses::CreateDayPass
    end
  end
end