class Demo::Clean::Rooms
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.each do |loc|
      loc.rooms.destroy_all
    end
  end
end