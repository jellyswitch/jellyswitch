# typed: false
class Checkins::CreateCheckin
  include Interactor::Organizer

  organize(
    Checkins::SaveCheckin,
    CreateNotifications
  )
end