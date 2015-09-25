require 'pineapples/actions'
#require 'pineapples/build_tasks/root_files'

module Pineapples
  class AppBuilder
    include Pineapples::Actions

    def root_files
      create_file '.ruby-version', "#{Pineapples::RUBY_VERSION}\n"
      create_file '.ruby-gemset', app_name

      template  'config.ru'
      template  'Gemfile'
      copy_file 'Guardfile'
      copy_file 'Procfile'
      copy_file 'Rakefile'

      copy_file '.gitignore'

      template  'README.md.tt'
      copy_file 'browserlist'
      copy_file '.editor-config'

      template  '.example.env.tt'

      if options.heroku?
        copy_file '.buildpacks'
        template 'Aptfile'
      end

      if !options.skip_test?
        copy_file '.example.rspec'
      end
    end

    def app_files
      directory 'app', except: 'user.rb'

      inside 'app' do
        keep_file 'assets/fonts'
        keep_file 'assets/images'
        if create_user_model?
          template 'models/user.rb.tt'
        else
          keep_file 'models'
        end
        keep_file 'mailers'

        keep_file 'controllers/concerns'
        keep_file 'models/concerns'
      end

    end

    def bin_files
      directory 'bin' do |content|
        "#{shebang}\n" + content
      end
      chmod 'bin', 0755 & ~File.umask, verbose: false
    end

    def config_files
      directory 'config'

      inside 'config' do
      end
    end

  end
end
