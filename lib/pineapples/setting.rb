require 'pineapples/highline/menu'

module Pineapples
  class Setting
    attr_reader :name, :type, :default, :question, :options
    attr_accessor :value

    VALID_TYPES = [:boolean, :numeric, :string, :symbol]

    # MENU_LAYOUT = %(<%= header ? "#{header}:\n" : '' %>) +
    #               "<%= list(menu, #{@flow.inspect}, #{@list_option.inspect}) %>"

    PROMPT = 'Select one of the options:'

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

      validate_default_type!
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
          agree(question_string)
        else
          ask(question_string, get_type_class)
        end
      end
    end

    private

    def ask_with_options
      menu = Highline::SettingMenu.new
      menu.header = header_string
      menu.answer_type = get_type_class
      menu.default = default if has_default?
      menu.choices(*options) { |selected| self.value = selected }
      say menu.inspect

      selected = ask(menu)
      menu.select(self, selected)
    end

    def header_string
      header_string = question
      # header_string << default_string if has_default?
    end

    def question_string
      question_string = question
      question_string << '?' if question_string[-1..1] != '?'
      question_string << default_string if has_default?
      question_string << '  '
    end

    def default_string
      " (default: #{default})"
    end

    def validate_default_type!
      default_type = case default
                     when nil
                       return
                     when TrueClass, FalseClass
                       :boolean
                     when Numeric, Hash, Array, String, Symbol
                       default.class.name.downcase.to_sym
                     end
      if default_type != type
        raise ArgumentError, "Setting's default value must match its type."
      end
    end

    def get_type_class
      Object.const_get(type.to_s.capitalize)
    end

  end
end
