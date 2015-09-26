module Pineapples
  class Setting
    attr_reader :name, :type, :default, :question, :options
    attr_accessor :value

    VALID_TYPES = [:boolean, :numeric, :hash, :array, :string, :symbol]

    def initialize(name, options = {})
      raise ArgumentError, "option name can't be nil" if name.nil?
      raise ArgumentError, "type can't be nil"        if options[:type].nil?

      type = options[:type].to_sym

      raise ArgumentError, "Type :#{type} is not valid for options." if type && !valid_type?(type)

      @name        = name
      @type        = type || :string
      @default     = options[:default]
      @value       = @default if @default
      @question    = options[:prompt]
      @options     = Array(options[:options])
    end

    def valid_type?(type)
      VALID_TYPES.include?(type)
    end

    def has_default?
      @default.present?
    end

    def has_options?
      @options.present?
    end

    def ask
    end

  end
end
