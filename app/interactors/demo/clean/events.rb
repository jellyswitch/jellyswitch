class Demo::Clean::Events
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.each do |loc|
      loc.events.destroy_all
    end
  end
end