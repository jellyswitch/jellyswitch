# typed: false
module Jellyswitch
  module Events
    class Jellyswitch::Events::Error < StandardError; end
    class SubscribeError < Jellyswitch::Events::Error; end

    class << self
      def registry
        @registry ||= Jellyswitch::Events::Registry.new
      end

      def register(event_name)
        registry.add_event(event_name)
      end

      def clear_registry!
        @registry = nil
      end

      attr_accessor :channel

      def publish(event_name, payload)
        channel.publish(event_name, payload)
      end

      def subscribe(event_name, klass = nil, &block)
        subscriber_name = klass.to_s
        raise SubscribeError, "must pass klass or block" if klass.nil? && !block_given?
        raise SubscribeError, "must only pass klass or block" if klass && block_given?

        if klass && !klass.respond_to?(:call)
          raise SubscribeError, "class #{klass} should respond to call"
        end

        channel.subscribe(event_name, subscriber_name) do |payload|
          klass ? klass.call(payload) : yield(payload)
        end
      end
    end

    self.channel = Jellyswitch::Events::Channel::ActiveSupportNotification.new
  end
end
