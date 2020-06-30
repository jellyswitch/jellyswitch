class Demo::Clean::Doors
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.each do |loc|
      loc.doors.destroy_all
    end
  end
end