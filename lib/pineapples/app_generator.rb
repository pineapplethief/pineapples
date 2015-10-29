require 'pineapples/actions'
require 'pineapples/helpers'
require 'pineapples/settings'

module Pineapples
  class AppGenerator
    extend Pineapples::Settings
    prepend Pineapples::Actions
    include Pineapples::Actions::Rails
    include Pineapples::Helpers

    TEMPLATING_ENGINES = [:erb, :haml, :slim]

    setting :template_engine, type: :symbol, default: :erb, options: TEMPLATING_ENGINES,
            prompt: 'Select templating engine to be used in the app'

    setting :carrierwave, type: :boolean, default: false,
            prompt: 'Wanna use Carrierwave for file uploads?'

    setting :devise, type: :boolean, default: true,
            prompt: 'Wanna use Devise for authentication?'

    setting :ajax_login, type: :boolean, default: true,
            prompt: 'Wanna login via ajax using devise?'

    setting :pundit, type: :boolean, default: true,
            prompt: 'Wanna use Pundit for authorization?'

    setting :user_role_field, type: :boolean, default: true,
            prompt: 'Wanna add role attribute to users model as simple user roles solution?'

    setting :bootstrap, type: :boolean, default: false,
            prompt: 'Wanna use Bootstrap on this project?'

    setting :use_rvm, type: :boolean, default: true,
            prompt: 'Want to create new RVM gemset for the app?'

    setting :heroku, type: :boolean, default: false,
            prompt: 'Wanna use Heroku?'

    setting :git_repo_url, type: :string, default: '',
            prompt: 'What is the git remote URL for this project?'

    setting :production_hostname, type: :string, default: '',
            prompt: 'Enter hostname for production site'

    setting :staging_hostname, type: :string, default: '',
            prompt: 'Enter hostname for staging site'

    attr_accessor :app_name,
                  :app_root,
                  :settings

    def initialize(options)
      @app_name = options.app_name.gsub(/\s+/, '-')
      @app_root = options.app_root || File.expand_path(app_name)
      @debug = options.debug || false
      @pretend = options.pretend || false
      @verbose = options.verbose || true
      @testing = options.testing || false

      @settings = self.class.settings
    end

    def start!
      valid_const! && check_target!
      create_app_root

      puts ajax_login
      puts ajax_login?

      # ask_user_settings

      create_root_files
      create_app_files
      create_bin_files
      create_config_files
      create_db_files
      create_lib_files
      create_public_files
      create_spec_files

      create_misc_folders

      setup_generated_app
    rescue Pineapples::Error => error
      (debug? || ENV['PINEAPPLES_DEBUG'] == '1') ? (raise error) : say(error.message.light_red)
      exit 1
    end

    def ask_user_settings
      settings[:heroku].ask_setting
      settings[:template_engine].ask_setting
    end

    def create_root_files
      create_file '.ruby-version', Pineapples::RUBY_VERSION
      create_file '.ruby-gemset', app_name
      copy_file '.editor-config'
      template '.example.env'
      copy_file '.example.rspec'
      copy_file '.gitignore'
      copy_file 'browserlist'
      template 'config.ru'
      template 'Gemfile'
      copy_file 'Guardfile'
      copy_file 'Procfile'
      template  'Procfile.dev'
      copy_file 'Rakefile'
      template 'README.md', 'README.md'
      if heroku?
        copy_file '.buildpacks'
        copy_file 'Aptfile'
      end
    end

    def create_app_files
      directory 'app'
      empty_directory_with_keep_file  'app/assets/fonts'
      empty_directory_with_keep_file  'app/assets/images'

      empty_directory_with_keep_file  'app/mailers'
      empty_directory_with_keep_file  'app/models' if !needs_user_model?
    end

    def create_bin_files
      directory 'bin'
      chmod 'bin/setup', '+x'
    end

    def create_config_files
      directory 'config'
    end

    def create_db_files
      empty_directory 'db/migrate'
      copy_migration 'enable_postgres_extensions'
      copy_migration 'create_data_migrations'
      if devise?
        copy_migration 'devise_create_users'
        copy_migration 'add_role_field_to_users' if user_role_field?
      end
    end

    def create_lib_files
      directory 'lib'
      keep_file 'lib/assets'
    end

    def create_public_files
      directory 'public'
    end

    def create_spec_files
      # directory 'spec'
    end

    def create_misc_folders
      keep_file 'log'

      empty_directory 'tmp/pids'

      inside 'vendor/assets' do
        empty_directory_with_keep_file 'javascripts'
        empty_directory_with_keep_file 'stylesheets'
      end
    end

    def setup_generated_app
      copy_example_files

      create_rvm_gemset! if rvm_installed? & use_rvm?
      shell_with_app_gemset 'bundle install'

      say_title 'Preparing database'
      shell_with_app_gemset 'bundle exec rake db:drop' if testing?
      shell_with_app_gemset 'bundle exec rake db:setup'
      shell_with_app_gemset 'bundle exec rake db:migrate'

      setup_git if !testing?
    end

    def copy_example_files
      say_title 'Copying sample files'
      copy_file '.example.env', '.env'
      copy_file '.example.rspec', '.rspec'
    end

    def create_rvm_gemset!
      say_title 'Creating project-specific RVM gemset'
      shell "rvm gemset create #{app_name}"
    end

    def setup_git
      if !preexisting_git_repo?
        say_title 'Setting up git repo'
        git :init
        git add: '-A .'
        git commit: %(-n -m "Generated Rails #{RAILS_VERSION.gsub('~> ', '')} project via pineapples gem")
        git checkout: '-b dev'
        if git_repo_url.present?
          git remote: "add origin #{git_repo_url.shellescape}"
          git push: '-u origin --all'
        end
      end
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

    def testing?
      @testing
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
