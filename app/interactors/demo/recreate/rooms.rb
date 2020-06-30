class Demo::Recreate::Rooms
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.each do |loc|
      create_rooms(loc)
    end
  end

  private

  def create_rooms(loc)
    room_data.each do |data|
      room = loc.rooms.create!(
        location_id: loc.id,
        operator_id: loc.operator.id,
        name: data[:name],
        description: data[:description],
        capacity: data[:capacity],
        square_footage: data[:square_footage],
        visible: data[:visible],
        av: data[:av],
        rentable: data[:rentable],
        hourly_rate_in_cents: data[:hourly_rate_in_cents]
      )
      room.photo.attach(io: File.open(Rails.root.join("app/assets/images/demo/rooms/#{data[:photo]}")), filename: data[:photo])
    end
  end

  def room_data
    # TODO put this into YAML to make it easier to iterate on later
    [
      {
        name: "Aspen",
        photo: "The Aspen Room.jpg",
        description: "A beautiful conference room suitable for medium-sized meetings",
        whiteboard: true,
        capacity: 6,
        square_footage: 600,
        visible: true,
        av: true,
        rentable: true,
        hourly_rate_in_cents: 6500
      },
      {
        name: "Cedar",
        photo: "The Cedar Room.jpg",
        description: "A quiet room suitable for small meetings",
        whiteboard: false,
        capacity: 4,
        square_footage: 250,
        visible: true,
        av: true,
        rentable: false,
        hourly_rate_in_cents: 1000
      },
      {
        name: "Sierra",
        photo: "The Sierra Room.jpg",
        description: "A profesionall meeting room suitable for medium-sized meetings",
        whiteboard: true,
        capacity: 4,
        square_footage: 400,
        visible: true,
        av: true,
        rentable: true,
        hourly_rate_in_cents: 4500
      },
      {
        name: "The Snow Cave",
        photo: "The Snow Cave.jpg",
        description: "A board room designed for large meetings",
        whiteboard: true,
        capacity: 12,
        square_footage: 1000,
        visible: true,
        av: true,
        rentable: true,
        hourly_rate_in_cents: 10000
      },
      {
        name: "The Tallac Room",
        photo: "The Tallac Room.jpg",
        description: "A large conference room suitable for meetings and events",
        whiteboard: true,
        capacity: 10,
        square_footage: 1200,
        visible: true,
        av: true,
        rentable: true,
        hourly_rate_in_cents: 10000
      }
    ]
  end
end