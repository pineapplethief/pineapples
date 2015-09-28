require 'pineapples/actions'
require 'pineapples/helpers'
require 'pineapples/settings'

module Pineapples
  class AppGenerator
    extend Pineapples::Settings
    include Pineapples::Helpers
    include Pineapples::Actions

    TEMPLATING_ENGINES = [:erb, :haml, :slim]

    setting :template_engine, type: :symbol, default: :erb, options: TEMPLATING_ENGINES,
            prompt: 'Select templating engine used in the app'

    attr_accessor :app_name, :app_root, :settings

    def initialize(options)
      @app_name = options.app_name.gsub(/\s+/, '-')
      @behaviour = options.behaviour || :invoke
      @app_root = File.expand_path(app_name)
      @settings = self.class.settings
      @debug = options.debug || false
    end

    def start!
      check_target!
      create_app_root

      ask_user_settings
    rescue Pineapples::Error => error
      (debug? || ENV['PINEAPPLES_DEBUG'] == '1') ? (raise error) : say(error.message.light_red)
      exit 1
    end

    def ask_user_settings
      settings[:template_engine].ask_setting
    end

    protected

    def check_target!
      if Dir["#{app_root}/*"].present?
        puts "I won't grow pineapples there, the target directory isn't empty."
        exit 1
      end
    end

    def create_app_root
      FileUtils::mkdir_p(app_root)
    end

    def debug?
      @debug
    end

  end
end
