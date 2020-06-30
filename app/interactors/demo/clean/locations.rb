class Demo::Clean::Locations
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.destroy_all
  end
end