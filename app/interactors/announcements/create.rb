class Announcements::Create
  include Interactor::Organizer

  organize(
    Announcements::Save,
    Announcements::SendEmail,
    CreateNotifications
  )
end