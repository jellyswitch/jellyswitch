# typed: false
class WeeklyUpdateJob < ApplicationJob
  queue_as :default

  def perform
    Operator.production.all.each do |operator|
      Time.use_zone(operator.locations.first.time_zone) do
        @week_start = Time.current.beginning_of_week - 1.week
        @week_end = Time.current.end_of_week - 1.week

        result = WeeklyUpdates::Create.call(operator: operator, week_start: @week_start, week_end: @week_end)
        if !result.success?
          Rollbar.error("Error creating weekly update: #{result.message}")
        end
      end
    end
  end
end
