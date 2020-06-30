class Demo::Clean::DoorPunches
  include Interactor

  delegate :operator, to: :context

  def call
    operator.door_punches.destroy_all
  end
end