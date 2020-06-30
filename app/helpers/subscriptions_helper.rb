# typed: false
module SubscriptionsHelper
  def find_subscription(key=:id)
    @subscription = Subscription.find(params[key])
  end

  def compute_start_day
    if params[:subscription][:start_day].present?
      Time.zone.at(params[:subscription][:start_day].to_i) + 2.hours
    else
      if params[:subscription]["start_day(1i)"].present?
        year = params[:subscription]["start_day(1i)"].to_i
        month = params[:subscription]["start_day(2i)"].to_i
        day = params[:subscription]["start_day(3i)"].to_i
        Time.zone.at(Date.new(year, month, day).beginning_of_day)
      else
        Time.zone.now + 2.hours
      end
    end
  end
end