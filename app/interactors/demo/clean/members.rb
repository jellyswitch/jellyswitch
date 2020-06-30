class Demo::Clean::Members
  include Interactor::Organizer

  organize(
    Demo::Clean::FeedItemComments,
    Demo::Clean::FeedItems,
    Demo::Clean::DoorPunches,
    Demo::Clean::Events,
    Demo::Clean::Announcements,
    Demo::Clean::MemberFeedbacks,
    Demo::Clean::Reservations,
    Demo::Clean::DeleteMembers,
  )
end