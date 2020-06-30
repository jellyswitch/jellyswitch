class Demo::Recreate::WeeklyUpdates
  include Interactor

  delegate :operator, to: :context

  def call
    Time.use_zone(operator.locations.first.time_zone) do
      week_start = Time.current.beginning_of_week
      week_end = Time.current.end_of_week

      result = ::WeeklyUpdates::Create.call(
        operator: operator, 
        week_start: week_start, 
        week_end: week_end
      )

      if !result.success?
        context.fail!(message: result.message)
      end
    end
  end
end