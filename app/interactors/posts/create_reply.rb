class Posts::CreateReply
  include Interactor::Organizer

  organize(
    Posts::SaveReply,
    CreateNotifications
  )
end