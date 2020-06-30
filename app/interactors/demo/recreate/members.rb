class Demo::Recreate::Members
  include Interactor::Organizer

  organize(
    Demo::Recreate::CreateMembers,
    Demo::Recreate::Admins,
    Demo::Recreate::Memberships
  )
end