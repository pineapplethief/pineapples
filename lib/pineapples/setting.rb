module Pineapples
  class Setting
    attr_reader :name, :type, :default, :question, :options
    attr_accessor :value

    VALID_TYPES = [:boolean, :numeric, :string, :symbol]

    def initialize(name, options = {})
      raise ArgumentError, "option name can't be nil" if name.nil?
      raise ArgumentError, "type can't be nil"        if options[:type].nil?

      type = options[:type].to_sym

      raise ArgumentError, "Type :#{type} is not valid for options." if type && !valid_type?(type)

      @name     = name
      @type     = type || :string
      @default  = options[:default]
      @value    = @default if @default
      @question = options[:prompt]
      @options  = Array(options[:options])

      validate_options_type!
      validate_type!(default)
      validate_value_in_options!(default)
    end

    def value=(setting)
      validate_type!(setting)
      validate_value_in_options!(setting)
      @value = setting
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

    VALID_TYPES.each do |type|
      define_method :"#{type}?" do
        self.type == type
      end
    end

    def ask_setting
      if has_options?
        ask_with_options
      else
        if boolean?
          ask_boolean
        else
          ask
        end
      end
    end

    private

    def ask_with_options
      puts
      index = Ask.list(question_string, options_with_color, inquirer_options)
      puts
      answer = options[index]
      self.value = cast_to_type(answer)
    end

    def ask_boolean
      puts
      self.value = Ask.confirm(question_string, inquirer_options)
      puts
    end

    def ask
      puts
      answer = Ask.input(question_string, inquirer_options)
      puts

      self.value = cast_to_type(answer)
    end

    def question_string
      result = ' ' * $terminal.indent_size
      result << question.light_yellow
      result << default_string if has_default?
    end

    def options_with_color
      options.map{ |option| option.to_s.light_blue }
    end

    def default_string
      " (default: #{default})".light_green
    end

    def cast_to_type(setting)
      case type
      when :numeric
        setting.to_f
      when :string
        setting.to_s
      when :symbol
        setting.to_sym
      else
        setting
      end
    end

    def validate_type(setting)
      value_type = case setting
                   when nil
                     return true
                   when TrueClass, FalseClass
                     :boolean
                   when Numeric, Hash, Array, String, Symbol
                     setting.class.name.downcase.to_sym
                   end
      type == value_type
    end

    def validate_type!(setting)
      if !validate_type(setting)
        raise ArgumentError, "Setting's value must match its type."
      end
    end

    def validate_value_in_options!(setting)
      raise ArgumentError, "New setting value must be one of the options" if !options.include?(setting)
    end

    def validate_options_type!
      if options.any?{ |option| !validate_type(option) }
        raise ArgumentError, "Option #{option} value doesn't match setting type"
      end
    end

    def get_type_class
      Object.const_get(type.to_s.capitalize)
    end

    def inquirer_options
      {clear: false, response: false}
    end

  end
end
