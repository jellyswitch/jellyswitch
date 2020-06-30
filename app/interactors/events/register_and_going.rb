class Events::RegisterAndGoing
  include Interactor::Organizer

  organize(
    Events::CreateUser,
    Crm::CreateLead,
    Events::Going
  )
end