# typed: true
module DayPassable
  class CheckInable::DefaultCheckin < SimpleDelegator
    attr_accessor :checkin

    def initialize(checkin)
      @checkin = checkin
    end

    def invoice_args
      {
        customer: checkin.billable.stripe_customer_id,
        auto_advance: true
      }
    end
  end
end