module Pineapples
  class Setting
    attr_reader :name, :type, :default, :question, :options

    VALID_TYPES = [:boolean, :numeric, :hash, :array, :string]

    def initialize(name, options = {})
      raise ArgumentError, "option name can't be nil" if name.nil?
      raise ArgumentError, "type can't be nil"        if options[:type].nil?

      type = options[:type].to_sym

      raise ArgumentError, "Type :#{type} is not valid for options." if type && !valid_type?(type)

      @name        = name
      @type        = type || :string
      @default     = options[:default]
      @question    = options[:prompt]
      @options     = options[:options]
    end

    def valid_type?(type)
      VALID_TYPES.include?(type)
    end

    def has_options?
      !@options.nil?
    end

    def ask
    end

  end
end
