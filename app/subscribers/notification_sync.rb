# typed: true
class NotificationSync
  def self.call(notifiable_id:, notifiable_type:)
    notifiable = notifiable_type.constantize.find(notifiable_id)

    NotifiableFactory.for(notifiable).notify
  end
end
