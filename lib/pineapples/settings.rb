require 'pineapples/setting'

module Pineapples
  module Settings
    def settings
      @settings
    end

    def setting(name, opts)
      raw_setting = Pineapples::Setting.new(name, opts)

      @settings ||= {}

      self.settings[name] = raw_setting

      puts self.inspect

      define_method name do
        self.settings[name].value
      end

      define_method :"#{name}=" do |value|
        self.settings[name].value = value
      end

      define_method :"#{name}?" do
        value = self.send(name)
        value.present?
      end
    end

  end
end
