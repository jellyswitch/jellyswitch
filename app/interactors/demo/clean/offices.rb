class Demo::Clean::Offices
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.each do |loc|
      loc.offices.destroy_all
    end
  end
end