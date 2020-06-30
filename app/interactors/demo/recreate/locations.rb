class Demo::Recreate::Locations
  include Interactor

  delegate :operator, to: :context

  def call
    locations.each do |location|
      result = Onboarding::CreateLocation.call(
        operator: operator,
        name: location[:name],
        description: location[:description],
        square_footage: location[:square_footage],
        street_address: location[:street_address],
        city: location[:city],
        state: location[:state],
        zip: location[:zip],
        time_zone: location[:time_zone],
        contact_name: "Dave Paola",
        contact_email: "dave@jellyswitch.com",
        contact_phone: "(530) 539-4799",
        wifi_name: "South Lake Coworking",
        wifi_password: "SLTCommunity123!"
      )
  
      if !result.success?
        context.fail!(message: result.message)
      end
    end
  end

  private

  def locations
    [
      {
        name: "The Summit",
        description: "South Lake Coworking is South Lake Tahoe’s first coworking space and a hub of innovation for the entire South Shore. We provide an innovative way to help you get your best work done by offering not only a cool place to do it, but a great community to do it with. Whether you are a freelancer, an entrepreneur, working remote, or just visiting, our mix of open-concept and private office space is perfectly suited to meet your workplace needs.",
        square_footage: 11000,
        street_address: "3079 Harrison Ave.",
        city: "South Lake Tahoe",
        state: "CA",
        zip: 96150,
        time_zone: "Pacific Time (US & Canada)",
      },
      {
        name: "Lakeview",
        description: "South Lake Coworking is South Lake Tahoe’s first coworking space and a hub of innovation for the entire South Shore. We provide an innovative way to help you get your best work done by offering not only a cool place to do it, but a great community to do it with. Whether you are a freelancer, an entrepreneur, working remote, or just visiting, our mix of open-concept and private office space is perfectly suited to meet your workplace needs.",
        square_footage: 5000,
        street_address: "3079 Harrison Ave.",
        city: "South Lake Tahoe",
        state: "CA",
        zip: 96150,
        time_zone: "Pacific Time (US & Canada)"
      },
      {
        name: "Basecamp",
        description: "South Lake Coworking is South Lake Tahoe’s first coworking space and a hub of innovation for the entire South Shore. We provide an innovative way to help you get your best work done by offering not only a cool place to do it, but a great community to do it with. Whether you are a freelancer, an entrepreneur, working remote, or just visiting, our mix of open-concept and private office space is perfectly suited to meet your workplace needs.",
        square_footage: 1000,
        street_address: "3079 Harrison Ave.",
        city: "South Lake Tahoe",
        state: "CA",
        zip: 96150,
        time_zone: "Pacific Time (US & Canada)"
      }
    ]
  end
end