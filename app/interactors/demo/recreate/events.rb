class Demo::Recreate::Events
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.each do |loc|
      Time.use_zone(loc.time_zone) do
        motivational_mondays(loc)
        book_club(loc)
        dev_meetup(loc)
        members_lunch(loc)
        womens_networking(loc)
        trivia_night(loc)
      end
    end
  end

  private

  def motivational_mondays(loc)
    week_offsets = Array(-4..4)

    filename = "motivational_mondays.jpg"
    week_offsets.each do |offset|
      start_date = (Time.current.beginning_of_week + 18.hours) + offset.weeks

      params = {
        location: loc,
        user: operator.users.admins.sample,
        title: "Motivational Mondays",
        description: "Meet up with fellow entrepreneurs to network, share ideas, get inspired and bring your ideas to life!",
        start_date: start_date,
        duration: 2,
        location_string: "The Lobby",
        filename: filename
      }

      create_event(params)
    end
  end

  def book_club(loc)
    start_date = (Time.current.beginning_of_week + 17.hours) + 2.weeks
    filename = "book_club.jpg"
    
    params = {
      location: loc,
      user: operator.users.admins.sample,
      title: "Book Release Party",
      description: "Join us as we celebrate our very own writer and member in the release of her new book, “Wall Walker”. Take a sneak peek here and gather for refreshments, a reading by the author, and Q&A.",
      start_date: start_date,
      duration: 3,
      location_string: "The Aspen Room",
      filename: filename
    }

    create_event(params)
  end

  def dev_meetup(loc)
    start_date = (Time.current.beginning_of_week + 12.hours) + 1.week
    filename = "dev_meetup.jpg"

    params = {
      location: loc,
      user: operator.users.admins.sample,
      title: "Dev Meetup",
      description: "Come out for beer + pizza, lightning talks, & all around good company. Not a developer? Come hang out anyway, everyone is invited!",
      start_date: start_date,
      duration: 3,
      location_string: "The Aspen Room",
      filename: filename
    }

    create_event(params)    
  end

  def members_lunch(loc)
    week_offsets = Array(-4..4)

    filename = "members_lunch.jpg"
    week_offsets.each do |offset|
      start_date = (Time.current.beginning_of_week + 1.day + 12.hours) + offset.weeks

      params = {
        location: loc,
        user: operator.users.admins.sample,
        title: "Member's Lunch",
        description: "Come mingle with your fellow members -- bring your lunch and get social.",
        start_date: start_date,
        duration: 1,
        location_string: "The Lobby",
        filename: filename
      }

      create_event(params)
    end
  end

  def womens_networking(loc)
    start_date = (Time.current.beginning_of_week + 2.days + 18.hours + 30.minutes) + 4.weeks
    filename = "womens_networking.jpg"
    
    params = {
      location: loc,
      user: operator.users.admins.sample,
      title: "Women's Networking Event",
      description: "Meetup with other inspiring ladies, share ideas, collaborate, and enjoy refreshments. Every Networking Event, will feature one of our members as a guest speaker. Please contact Community Manager if you’d like to speak.",
      start_date: start_date,
      duration: 3,
      location_string: "The Aspen Room",
      filename: filename
    }

    create_event(params)
  end

  def trivia_night(loc)
    week_offsets = Array(-4..4)

    filename = "trivia_night.jpg"
    week_offsets.each do |offset|
      start_date = (Time.current.beginning_of_week + 2.days + 18.hours) + offset.weeks

      params = {
        location: loc,
        user: operator.users.admins.sample,
        title: "Trivia Night",
        description: "The best way to spend your Wednesday evening and meet other trivia aficionados. Beer and random knowledge- does it get any better? ",
        start_date: start_date,
        duration: 3,
        location_string: "The Brewery",
        filename: filename
      }

      create_event(params)
    end
  end

  def create_event(params)
    result = ::Events::Create.call(
      location: params[:location],
      user: operator.users.admins.sample,
      event_params: {
        title: params[:title],
        description: params[:description],
        starts_at: time_format(params[:start_date]),
        ends_at: time_format(params[:start_date] + params[:duration].hours),
        location_string: params[:location_string]
      }
    )
    result.event.image.attach(io: image = File.open(Rails.root.join("app/assets/images/demo/events/#{params[:filename]}")), filename: params[:filename])
  end
  
  def time_format(stamp)
    stamp.strftime("%m/%d/%Y %l:%M %p")
  end
end