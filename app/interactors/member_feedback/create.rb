# typed: true
class MemberFeedback::Create
  include Interactor::Organizer

  organize(
    MemberFeedback::Save,
    CreateNotifications
  )
end