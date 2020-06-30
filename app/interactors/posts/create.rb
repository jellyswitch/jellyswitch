class Posts::Create
  include Interactor::Organizer

  organize(
    Posts::Save,
    CreateNotifications
  )
end