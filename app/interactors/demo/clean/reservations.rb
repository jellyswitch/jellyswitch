class Demo::Clean::Reservations
  include Interactor

  delegate :operator, to: :context

  def call
    operator.rooms.each do |room|
      room.reservations.destroy_all
    end
  end
end