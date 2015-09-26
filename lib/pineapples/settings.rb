require 'pineapples/setting'

module Pineapples
  module Settings
    def setting(name, opts)
      raw_setting = Pineapples::Setting.new(name, opts)

      settings[name] = raw_setting

      attr_accessor name

      define_method :"#{name}?" do
        value = self.send(name)
        value.present?
      end

      # set default value if applicable
      send(:"#{name}=", raw_setting.default) if raw_setting.has_default?
    end

    def configure(&block)
      instance_eval &block
    end
    alias_method :configure, :config

  end
end
