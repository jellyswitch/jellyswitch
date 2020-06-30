class AnnouncementMailerPreview < ActionMailer::Preview
  def notification
    AnnouncementMailer.notification(Announcement.last, User.first)
  end
end