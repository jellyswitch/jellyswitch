class Events::Cancel
  include Interactor::Organizer

  organize(
    Events::EmailCancellation,
    Events::Destroy
  )
end