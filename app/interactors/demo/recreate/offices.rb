class Demo::Recreate::Offices
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.each do |loc|
      create_offices(loc)
    end
  end

  private

  def create_offices(loc)
    office_data.each do |data|
      office = loc.offices.create!(
        name: data[:name],
        description: data[:description],
        capacity: data[:capacity],
        square_footage: data[:square_footage],
        visible: data[:visible],
        operator_id: loc.operator.id
      )
      office.photo.attach(io: File.open(Rails.root.join("app/assets/images/demo/offices/generic.png")), filename: "generic.png")
    end
  end

  def office_data
    Array(1..10).map do |i|
      {
        name: "Office #{i.to_i}",
        description: nil,
        capacity: 4,
        square_footage: 120,
        visible: true
      }
    end
  end
end