# typed: false
module MemberFeedbackHelper
  def member_feedback_who(member_feedback)
    if member_feedback.anonymous?
      "Anonymous"
    else
      link_to member_feedback.user.name, user_path(member_feedback.user)
    end
  end
end