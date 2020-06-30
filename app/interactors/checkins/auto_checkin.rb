# typed: false
class Checkins::AutoCheckin
  include Interactor::Organizer

  organize(
    Checkins::CreateAutoCheckin,
    Checkins::SaveCheckin
  )
end