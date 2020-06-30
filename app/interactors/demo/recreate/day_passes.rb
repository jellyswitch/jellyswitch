class Demo::Recreate::DayPasses
  include Interactor
  include RandomTimestamps

  delegate :operator, to: :context

  def call
    puts 'Creating day passes...'
    operator.locations.each do |loc|
      Time.use_zone(loc.time_zone) do
        # go back 6 weeks
        (1..6).each do |week|
          week_start = Time.current.beginning_of_week - week.weeks
          
          create_day_passes(week_start)
        end
      end
    end
    puts "done."
  end

  private

  def create_day_passes(week)
    # pick a user at random
    user = operator.users.approved.sample

    day_pass_params = {
      day: temp_day,
      day_pass_type: operator.day_pass_types.sample.id,
      created_at: temp_day,
      operator: operator
    }

    result = DayPassInteractorFactory.for(nil, operator).call(
      params: day_pass_params,
      user_id: user.id,
      token: nil,
      operator: operator,
      out_of_band: true,
      location: operator.locations.sample
    )
  end
end