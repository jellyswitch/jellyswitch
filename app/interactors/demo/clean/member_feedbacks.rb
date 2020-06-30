class Demo::Clean::MemberFeedbacks
  include Interactor

  delegate :operator, to: :context

  def call
    operator.member_feedbacks.destroy_all
  end
end