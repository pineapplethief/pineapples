require 'rails/generators'
require 'rails/generators/rails/app/app_generator'
require 'pineapples/helpers'

module Pineapples
  module Generators
    RAILS_DEV_PATH = File.expand_path("../../../../../..", File.dirname(__FILE__))
    RESERVED_NAMES = %w[application destroy plugin runner test]

    class AppGenerator < Rails::Generators::AppGenerator
      include Pineapples::Helpers

      TEMPLATING_ENGINES = [:erb, :haml, :slim]

      Thor::Base.shell = Thor::Shell::Color

      class_option :database, type: :string, aliases: '-d', default: 'postgresql',
        desc: "Configure for selected database (options: #{DATABASES.join("/")})"

      class_option :template_engine, type: :symbol, default: :erb,
        desc: "Templating engine used in the app (options: #{TEMPLATING_ENGINES.join("/")})"

      class_option :heroku, type: :boolean, aliases: '-H', default: false,
        desc: 'Create staging and production Heroku apps'

      class_option :heroku_flags, type: :string, default: '',
        desc: 'Set extra Heroku flags'

      class_option :devise, type: :boolean, default: true,
        desc: 'Use devise for authentication'

      class_option :pundit, type: :boolean, default: true,
        desc: 'Use pundit for authorization'

      class_option :user_role_field, type: :boolean, default: true,
        desc: 'Add role field to users table and make it enum with sensible default values for simple role management'

      class_option :carrierwave, type: :boolean,
        desc: 'Use carrierwave for image uploading and processing'

      class_option :bootstrap, type: :boolean, default: false
        desc: 'Use Bootstrap as front-end framework'

      class_option :github, type: :string, aliases: '-G', default: nil,
        desc: 'Create Github repository and add remote origin pointed to repo'

      class_option :test_generator, type: :boolean, aliases: '-t', default: true,
        desc: 'Speed manual testing of generator'

      def initialize(*args)
        super
      end

      # hook to do stuff before everything else
      def start_template
      end

      def ask_user_preferences
        say 'ask_user_preferences'
        say "#{Thor::Base.shell.class}"
        options[:heroku] = ask_with_default('Use Heroku for hosting?', 'yes').yes?
      end

      def create_root_files
        build(:root_files)
      end

      def create_app_files
        build(:app_files)
      end

      def create_bin_files
        build(:bin_files)
      end

      def create_config_files
        build(:config_files)
      end

      def update_config_files
      end
      remove_task :update_config_files

      def create_boot_file
      end

      def create_active_record_files
      end

      def create_db_files
        build(:db_files)
      end

      def create_lib_files
        build(:lib_files)
      end

      def create_log_files
        build(:log_files)
      end

      def create_public_files
        build(:public_directory)
      end

      def create_test_files
        build(:test_files) unless options[:skip_test]
      end

      def create_tmp_files
        build(:tmp_files)
      end

      def create_vendor_files
        build(:vendor_files)
      end

      def delete_js_folder_skipping_javascript
        if options[:skip_javascript]
          remove_dir 'app/assets/javascripts'
        end
      end

      def delete_assets_initializer_skipping_sprockets
        if options[:skip_sprockets]
          remove_file 'config/initializers/assets.rb'
        end
      end

      def delete_active_record_initializers_skipping_active_record
        if options[:skip_active_record]
          remove_file 'config/initializers/active_record_belongs_to_required_by_default.rb'
        end
      end

      def finish_template
        build(:leftovers)
      end

      protected

      def get_builder_class
        Pineapples::AppBuilder
      end

      # skip bundle install when testing generator
      def bundle_install?
        options[:test_generator] ? false : super
      end

      def using_active_record?
        !options[:skip_active_record]
      end

      def create_user_model?
        options[:devise] || options[:pundit] || options[:user_role_field]
      end

      def comment_if_not(value)
        options[value] ? '' : '# '
      end

    end
  end
end
