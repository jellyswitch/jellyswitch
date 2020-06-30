class Demo::Recreate::Reservations
  include Interactor

  delegate :operator, to: :context

  def call
    puts 'Creating reservations...'
    operator.locations.each do |loc|
      Time.use_zone(loc.time_zone) do
        # go back 6 weeks
        (0..3).each do |week|
          week_start = Time.current.beginning_of_week - week.weeks
          
          (1..5).each do |offset|
            day = week_start + offset
            (1..4).each do |hour_offset|
              loc.rooms.each do |room|
                if loc.rooms.first == room
                  create_reservation(room, day + (8+hour_offset).hours)
                  create_reservation(room, day + (10+hour_offset).hours)
                  create_reservation(room, day + (13+hour_offset).hours)
                else
                  create_reservation(room, day + (8+hour_offset).hours)
                end
              end
            end
          end
        end
      end
    end
    puts "done."
  end

  private

  def create_reservation(room, datetime_in)
    # pick a user at random
    user = operator.users.approved.first
    
    result = Billing::Reservations::CreateRoomReservation.call(reservation_params: {
      datetime_in: datetime_in,
      hours: 1,
      minutes: 60,
      room: room
    }, user: user)
  end
end