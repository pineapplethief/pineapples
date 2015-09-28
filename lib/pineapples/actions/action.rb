module Pineapples
  module Actions
    class Action
      # Reference to AppGenerator instance
      attr_reader :generator

      # Action could success or throw a error
      attr_accessor :status

      # Error message
      attr_accessor :error

      # Options hash
      attr_accessor :options

      def initialize(generator, behavior, options)
        @generator = generator
        @options = {log: false}.merge(options)
      end

      def invoke!
      end

      def revoke!
      end

      protected

      def pretend?
        generator.options[:pretend]
      end

      def log
      end

      def message
      end

    end
  end
end
