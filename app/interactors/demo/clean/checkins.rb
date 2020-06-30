class Demo::Clean::Checkins
  include Interactor

  delegate :operator, to: :context

  def call
    operator.locations.each do |loc|
      loc.checkins.each do |checkin|
        checkin.destroy
      end
    end
  end
end