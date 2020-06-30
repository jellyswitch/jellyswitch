# typed: false
module Jellyswitch
  module Events
    module Channel
      class Sidekiq
        class EventWorker
          class MissingSubscriptionError < StandardError
            attr_reader :subscriber_name, :event_name
            private :subscriber_name, :event_name

            def initialize(event_name, subscriber_name, payload)
              @event_name = event_name
              @subscriber_name = subscriber_name
              @payload = payload
            end

            def message
              "missing subscription '#{subscriber_name}' for event '#{event_name}'"
            end
          end

          include ::Sidekiq::Worker

          sidekiq_options queue: "jellyswitch.events", retry: 25

          def perform(event_name, subscriber_name, payload)
            channel = Jellyswitch::Events::Channel::Sidekiq.instance

            subscriber = channel.subscriber(event_name, subscriber_name)

            transformed_payload = payload.deep_transform_keys(&:to_sym)

            unless subscriber
              raise MissingSubscriptionError.new(event_name, subscriber_name, transformed_payload)
            end

            subscriber.call(transformed_payload)
          end
        end

        class << self
          def instance
            @instance ||= new
          end
        end

        attr_reader :subscriptions, :worker_klass
        private :worker_klass

        def initialize(worker_klass = EventWorker)
          @worker_klass = worker_klass
          @subscriptions = {}
        end

        def publish(event_name, payload)
          subscription_names(event_name).each do |subscriber_name|
            worker_klass.perform_async(event_name, subscriber_name, payload)
          end
        end

        def subscribe(event_name, subscriber_name, &block)
          raise ArgumentError, "Missing block handler" unless block_given?
          subscriptions[event_name] ||= {}
          subscriptions[event_name][subscriber_name.to_s] = block
        end

        def subscriber(event_name, subscriber_name)
          subscriptions[event_name] && subscriptions[event_name][subscriber_name.to_s]
        end

        private

        def subscription_names(event_name)
          (subscriptions[event_name] || {}).keys
        end
      end
    end
  end
end
