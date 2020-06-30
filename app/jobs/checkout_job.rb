# typed: false
class CheckoutJob < ApplicationJob
  queue_as :default

  def perform
    Operator.production.all.each do |operator|
      operator.locations.each do |location|
        location.checkins.open.each do |checkin|
          Time.use_zone(location.time_zone) do
            result = Checkins::Checkout.call(checkin: checkin, datetime_out: checkin.auto_checkout_time)

            if !result.success?
              puts result.message
              Rollbar.error("Error auto-checking out: #{result.message}")
            end
          end
        end
      end
    end
  end
end
