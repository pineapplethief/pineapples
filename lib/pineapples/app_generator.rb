require 'pineapples/actions'
require 'pineapples/actions/rails/rails'
require 'pineapples/helpers'
require 'pineapples/settings'

module Pineapples
  class AppGenerator
    extend Pineapples::Settings
    prepend Pineapples::Actions
    include Pineapples::Actions::Rails
    include Pineapples::Helpers

    TEMPLATING_ENGINES = [:erb, :haml, :slim]

    setting :heroku, type: :boolean, default: false,
            prompt: 'Wanna use Heroku?'

    setting :template_engine, type: :symbol, default: :erb, options: TEMPLATING_ENGINES,
            prompt: 'Select templating engine to be used in the app'

    setting :carrierwave, type: :boolean, default: false,
            prompt: 'Wanna use Carrierwave for file uploads?'

    setting :devise, type: :boolean, default: true,
            prompt: 'Wanna use Devise for authentication?'

    setting :pundit, type: :boolean, default: true,
            prompt: 'Wanna use Pundit for authorization?'

    setting :user_role_field, type: :boolean, default: true,
            prompt: 'Wanna add role attribute to users model as simple user roles solution?'

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
      valid_const! && check_target!
      create_app_root
      ask_user_settings

      create_root_files
      #create_app_files
      #run_after_bundle_callbacks
    rescue Pineapples::Error => error
      (debug? || ENV['PINEAPPLES_DEBUG'] == '1') ? (raise error) : say(error.message.light_red)
      exit 1
    end

    def ask_user_settings
      settings[:heroku].ask_setting
      # settings[:template_engine].ask_setting
    end

    def create_root_files
      copy_file '.editor-config'
      template '.example.env'
      copy_file '.example.rspec'
      copy_file '.gitignore'
      copy_file 'browserlist'
      template 'config.ru'
      template 'Gemfile'
      copy_file 'Guardfile'
      copy_file 'Procfile'
      copy_file 'Rakefile'
      template 'README.md', 'README.md'
      if heroku?
        copy_file '.buildpacks'
        copy_file 'Aptfile'
      end
    end

    def create_app_files
      directory 'app'
    end

    def create_bin_files
    end

    def create_config_files
    end

    def create_db_files

    end

    def run_after_bundle_callbacks
      @after_bundle_callbacks.each(&:call)
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

    def create_app_root
      FileUtils::mkdir_p(app_root)
      say_status :create_root, 'Created application root'
    end

    def check_target!
      if Dir["#{app_root}/*"].present?
        puts "I won't grow pineapples there, the target directory isn't empty."
        exit 1
      end
    end

  end
end
