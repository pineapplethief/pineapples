module Pineapples
  module Settings
    class Option
      attr_accessor :name, :type, :default, :desc

      def initialize(name, type, default, desc)
        @name = name
        @type = type
        @default = default
        @desc = desc
      end
    end

  end
end
