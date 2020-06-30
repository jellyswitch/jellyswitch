class FeedItems::CreateComment
  include Interactor::Organizer

  organize(
    FeedItems::SaveComment,
    CreateNotifications
  )
end