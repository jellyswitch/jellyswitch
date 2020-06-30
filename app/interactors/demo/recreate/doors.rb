class Demo::Recreate::Doors
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.each do |loc|
      Door.create!(name: "Front Door", location_id: loc.id, operator_id: operator.id)
      Door.create!(name: "Back Door", location_id: loc.id, operator_id: operator.id)
    end
  end
end