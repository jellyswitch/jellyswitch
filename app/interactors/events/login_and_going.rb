class Events::LoginAndGoing
  include Interactor::Organizer

  organize(
    ::Authenticate,
    Events::Going
  )
end