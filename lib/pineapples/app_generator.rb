require 'pineapples/actions'
require 'pineapples/actions/rails/rails'
require 'pineapples/settings'

module Pineapples
  class AppGenerator
    extend Pineapples::Settings
    prepend Pineapples::Actions
    include Pineapples::Actions::Rails

    TEMPLATING_ENGINES = [:erb, :haml, :slim]

    setting :template_engine, type: :symbol, default: :erb, options: TEMPLATING_ENGINES,
            prompt: 'Select templating engine used in the app'

    attr_accessor :app_name,
                  :app_root,
                  :settings

    def initialize(options)
      @app_name = options.app_name.gsub(/\s+/, '-')
      @app_root = options.app_root || File.expand_path(app_name)
      @debug = options.debug || false
      @pretend = options.pretend || false
      @verbose = options.verbose || true

      @settings = self.class.settings
    end

    def start!
      create_app_root
      ask_user_settings

      create_root_files
    rescue Pineapples::Error => error
      (debug? || ENV['PINEAPPLES_DEBUG'] == '1') ? (raise error) : say(error.message.light_red)
      exit 1
    end

    def ask_user_settings
      settings[:template_engine].ask_setting
    end

    def run_after_bundle_callbacks
      @after_bundle_callbacks.each(&:call)
    end

    def create_root_files
      template 'README.md', 'README.md'
    end

    def debug?
      @debug
    end

    def pretend?
      @pretend
    end

    def execute?
      !pretend?
    end

    def verbose?
      @verbose
    end

    protected

    def check_target!
      if Dir["#{app_root}/*"].present?
        puts "I won't grow pineapples there, the target directory isn't empty."
        exit 1
      end
    end

    def create_app_root
      check_target!
      FileUtils::mkdir_p(app_root)
    end

  end
end
