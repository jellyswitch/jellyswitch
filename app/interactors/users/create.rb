# typed: true
class Users::Create
  include Interactor::Organizer

  organize(
    Users::Save,
    CreateNotifications
  )

end
