# typed: true
class MemberFeedback::Save
  include Interactor
  include FeedItemCreator

  def call
    member_feedback = MemberFeedback.new(context.member_feedback_params)
    member_feedback.user = context.user
    member_feedback.operator = context.operator

    if !member_feedback.save
      context.fail!(message: "Couldn't submit feedback.")
    end

    context.member_feedback = member_feedback
    context.notifiable = member_feedback
  end
end