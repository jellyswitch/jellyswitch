# typed: true
class BillableFactory
   def self.for(invoiceable)
    case invoiceable.class.name
    when "Subscription"
      Billable::Subscription
    when "Checkin"
      Billable::Checkin
    when "DayPass"
      Billable::DayPass
    else
      raise "Cannot determine billable for #{invoiceable.class.name}"
    end.new(invoiceable)
  end
end