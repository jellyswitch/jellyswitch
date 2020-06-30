class FeedItems::Create
  include Interactor::Organizer

  organize(
    FeedItems::Save,
    CreateNotifications
  )
end