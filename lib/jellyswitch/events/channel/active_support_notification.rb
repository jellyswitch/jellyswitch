# typed: true
module Jellyswitch
  module Events
    module Channel
      class ActiveSupportNotification
        def publish(event_name, payload)
          ActiveSupport::Notifications.instrument(event_name, payload)
        end

        def subscribe(event_name, subscriber_name)
          ActiveSupport::Notifications.subscribe event_name do |*args|
            event = ActiveSupport::Notifications::Event.new(*args)
            yield event.payload.deep_transform_keys(&:to_sym)
          end
        end
      end
    end
  end
end
