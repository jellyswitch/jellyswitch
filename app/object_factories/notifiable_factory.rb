# typed: false
class NotifiableFactory
  def self.for(notifiable)
    case notifiable.class.name
    when 'Announcement'
      Notifiable::Announcement
    when 'Checkin'
      Notifiable::Checkin
    when 'ChildcareReservation'
      Notifiable::ChildcareReservation
    when 'DayPass'
      Notifiable::DayPass
    when 'FeedItem'
      Notifiable::FeedItem
    when 'FeedItemComment'
      Notifiable::FeedItemComment
    when 'MemberFeedback'
      Notifiable::MemberFeedback
    when 'Post'
      Notifiable::Post
    when 'PostReply'
      Notifiable::PostReply
    when 'Reservation'
      Notifiable::Reservation
    when 'Subscription'
      Notifiable::Subscription
    when 'User'
      Notifiable::User
    when 'WeeklyUpdate'
      Notifiable::WeeklyUpdate
    end.new(notifiable)
  end
end
