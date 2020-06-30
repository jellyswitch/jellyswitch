class Demo::Clean::DeleteMembers
  include Interactor

  delegate :operator, to: :context

  def call
    operator.users.destroy_all
  end
end