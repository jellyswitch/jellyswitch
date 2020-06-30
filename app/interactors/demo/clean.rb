class Demo::Clean
  include Interactor::Organizer

  organize(
    Demo::SelectOperator,
    Demo::Clean::Invoices, # TODO (Leases)
    Demo::Clean::Organizations, # TODO
    Demo::Clean::Members,
    Demo::Clean::Offices,
    Demo::Clean::Rooms,
    Demo::Clean::Doors,
    Demo::Clean::Plans,
    Demo::Clean::DayPassTypes,
    Demo::Clean::WeeklyUpdates,
    Demo::Clean::Locations,
    Demo::Recreate::Locations,
    Demo::Recreate::DayPassTypes,
    Demo::SelectOperator,
    Demo::Recreate::Plans,
    Demo::Recreate::Doors,
    Demo::Recreate::Rooms,
    Demo::Recreate::Offices,
    Demo::Recreate::Members,
    Demo::SelectOperator,
    Demo::Recreate::Reservations,
    Demo::Recreate::MemberFeedbacks,
    Demo::Recreate::DayPasses,
    Demo::Recreate::Announcements,
    Demo::Recreate::Events,
    # Demo::Recreate::DoorPunches,
    Demo::Recreate::FeedItems,
    # Demo::Recreate::FeedItemComments,
    Demo::Recreate::Invoices,
    Demo::Recreate::WeeklyUpdates
  )

end