# typed: true
module Jellyswitch
  module Events
    class Registry
      class RegistryError < StandardError; end

      def initialize
        @register_set = Set.new
      end

      def add_event(name)
        if @register_set.include?(name)
          raise RegistryError, "Event name has already been registered"
        end

        @register_set << name
        true
      end
    end
  end
end
