# typed: true
class Checkins::CreateAutoCheckin
  include Interactor

  delegate :user_id, :location, to: :context

  def call
    context.user = User.find(user_id)
    context.location = location
    context.operator = location.operator
    
  end
end