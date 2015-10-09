module Pineapples
  module Actions
    class Action
      STATUS_COLORS = {creative: :light_green,
                       destructive: :light_red,
                       neutral: :light_blue,
                       warning: :light_yellow}

      # Reference to AppGenerator instance
      attr_reader :generator

      attr_reader :colors

      # Options hash
      attr_accessor :options

      # Let status colors set by .status_color macro be inherited
      def self.inherited(child_class)
        super
        child_class.instance_variable_set('@colors', self.colors)
      end

      def self.status_color(status, color)
        colors[status] = color
      end

      def self.colors
        @colors ||= {}
      end

      def initialize(generator, options = {})
        @generator = generator
        @options = options
      end

      def invoke!
        raise NotImplementedError, "You should really implement invoke! method on Action subclasses"
      end

      protected

      def pretend?
        generator.pretend?
      end

      def execute?
        !pretend?
      end

      def verbose?
        options[:verbose] || generator.verbose?
      end

      # used to log action actions (no pun intended)
      def say_status(status, message = self.message, color = nil)
        color = color(status) if color.nil?
        generator.say_status(status, message, color) if verbose?
      end

      def color(status)
        color = self.class.colors[status]
        color = STATUS_COLORS[color] if STATUS_COLORS.keys.include?(color)
      end

    end
  end
end
