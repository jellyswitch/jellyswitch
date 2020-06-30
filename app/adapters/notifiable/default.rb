class Notifiable::Default < SimpleDelegator
  # Invoked by the factory
  def notify
    log
    validate!
    create_feed_item
    send_notification if should_send_notification?
  end

  def log
    puts "Pushing message to #{recipients.count} recipients: #{message}"
  end

  def validate!
    if message.blank?
      raise "Push notification message can't be blank."
    end
    
    recipients # will raise an error if not defined
  end
  
  def send_notification
    ios
    android
  end

  def ios
    if operator.push_notification_certificate.attached?
      apn = Houston::Client.production
      apn.certificate = operator.push_notification_certificate.download

      recipients.each do |user|
        puts "Pushing iOS notification to #{user.name}: #{message}"

        if user.ios_token.present?
          notification = Houston::Notification.new(device: user.ios_token)
          notification.alert = message
    
          apn.push(notification)
          puts "Pushed iOS message: #{message} to #{user.name}'s device: #{user.ios_token}"
        else
          puts "Cannot push iOS message to #{user.email} since iOS token is: #{user.ios_token}"
        end

      end
    else
      puts "Operator #{operator.name} has no push notification certificate."
    end
  end

  def android
    if operator.android_server_key.present?
      recipients.each do |user|
        puts "Pushing android notification to #{user.name}: #{message}"
        if user.android_token.present?
          fcm = FCM.new(operator.android_server_key)
          fcm.send([user.android_token], {"notification": {"title": message, "body": message}})
          
          puts "Pushed message: #{message} to #{user.name}'s android device: #{user.android_token}"
        else
          puts "Cannot push Android message to #{user.email} since android token is: #{user.android_token}"
        end
      end
    else
      puts "Operator #{operator.name} has no firebase server key."
    end
  end
  
  def message
    raise "Implement in a subclass"
  end
  
  def recipients
    raise "Implement in subclass"
  end
  
  def should_send_notification?
    raise "Implement in a subclass"
  end
  
  def recipients
    raise "Implement in a subclass"
  end
  
  def create_feed_item
    raise "Implement in a subclass"
  end
end