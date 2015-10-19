require_relative 'erb_converters'

module Pineapples
  module Actions
    module Rails

      def initialize(*) # :nodoc:
        super
        @after_bundle_callbacks = []
      end
      # Adds a line inside the Application class for <tt>config/application.rb</tt>.
      #
      # If options <tt>:env</tt> is specified, the line is appended to the corresponding
      # file in <tt>config/environments</tt>.
      #
      #   environment do
      #     "config.autoload_paths += %W(#{config.root}/extras)"
      #   end
      #
      #   environment(nil, env: "development") do
      #     "config.autoload_paths += %W(#{config.root}/extras)"
      #   end
      def environment(content = nil, options = {})
        sentinel = /class [a-z_:]+ < Rails::Application/i
        env_file_sentinel = /Rails\.application\.configure do/
        content = yield if !content && block_given?

        in_root do
          if options[:env].nil?
            insert_into_file 'config/application.rb', "\n    #{content}",
                              after: sentinel, verbose: false
          else
            Array(options[:env]).each do |env|
              insert_into_file "config/environments/#{env}.rb", "\n  #{content}",
                                after: env_file_sentinel, verbose: false
            end
          end
        end
      end
      alias :application :environment

      # Create a new file in the <tt>vendor/</tt> directory. Code can be specified
      # in a block or a data string can be given.
      #
      #   vendor("sekrit.rb") do
      #     sekrit_salt = "#{Time.now}--#{3.years.ago}--#{rand}--"
      #     "salt = '#{sekrit_salt}'"
      #   end
      #
      #   vendor("foreign.rb", "# Foreign code is fun")
      def vendor(filename, content = nil, &block)
        log :vendor, filename
        create_file("vendor/#{filename}", content, verbose: false, &block)
      end

      # Create a new file in the lib/ directory. Code can be specified
      # in a block or a data string can be given.
      #
      #   lib("crypto.rb") do
      #     "crypted_special_value = '#{rand}--#{Time.now}--#{rand(1337)}--'"
      #   end
      #
      #   lib("foreign.rb", "# Foreign code is fun")
      def lib(filename, content = nil, &block)
        say_status :lib, filename, color_from_behaviour
        create_file("lib/#{filename}", content, verbose: false, &block)
      end

      # Create a new +Rakefile+ with the provided code (either in a block or a string).
      #
      #   rakefile("bootstrap.rake") do
      #     project = ask("What is the UNIX name of your project?")
      #
      #     <<-TASK
      #       namespace :#{project} do
      #         task :bootstrap do
      #           puts "I like boots!"
      #         end
      #       end
      #     TASK
      #   end
      #
      #   rakefile('seed.rake', 'puts "Planting seeds"')
      def rakefile(filename, content = nil, &block)
        say_status :lib, filename, color_from_behaviour
        rake_extention = File.extname(filename) == '.rake'
        filename = rake_extention ? filename : "#{filename}.rake"
        create_file("lib/tasks/#{filename}", content, verbose: false, &block)
      end

      # Create a new initializer with the provided code (either in a block or a string).
      #
      #   initializer("globals.rb") do
      #     data = ""
      #
      #     ['MY_WORK', 'ADMINS', 'BEST_COMPANY_EVAR'].each do |const|
      #       data << "#{const} = :entp\n"
      #     end
      #
      #     data
      #   end
      #
      #   initializer("api.rb", "API_KEY = '123456'")
      def initializer(filename, content = nil, &block)
        say_status :initializer, filename, color_from_behaviour
        create_file("config/initializers/#{filename}", content, verbose: false, &block)
      end

      # Generate something using a generator from Rails or a plugin.
      # The second parameter is the argument string that is passed to
      # the generator or an Array that is joined.
      #
      #   generate(:authenticated, "user session")
      def generate(what, *args)
        say_status :generate, what, color_from_behaviour
        arguments = args.flat_map(&:to_s).join(' ')

        in_root { ruby("bin/rails generate #{what} #{arguments}", verbose: false) }
      end

      # Runs the supplied rake task
      #
      #   rake("db:migrate")
      #   rake("db:migrate", env: "production")
      #   rake("gems:install", sudo: true)
      def rake(command, options = {})
        say_status :rake, command, color_from_behaviour
        env  = options[:env] || ENV['RAILS_ENV'] || 'development'
        sudo = options[:sudo] && RbConfig::CONFIG['host_os'] !~ /mswin|mingw/ ? 'sudo ' : ''
        in_root { shell("#{sudo}rake #{command} RAILS_ENV=#{env}", verbose: false) }
      end

      # Make an entry in Rails routing file <tt>config/routes.rb</tt>
      #
      #   route "root 'welcome#index'"
      def route(routing_code)
        say_status :route, routing_code, color_from_behaviour
        sentinel = /\.routes\.draw do\s*\n/m

        in_root do
          insert_into_file 'config/routes.rb', "  #{routing_code}\n", {after: sentinel, verbose: false, force: true}
        end
      end

      # Registers a callback to be executed after bundle and spring binstubs
      # have run.
      #
      #   after_bundle do
      #     git add: '.'
      #   end
      def after_bundle(&block)
        @after_bundle_callbacks << block
      end

      protected

      def color_from_behaviour
        behaviour == :invoke ? :light_green : :light_red
      end

      # Surround string with single quotes if there is no quotes.
      # Otherwise fall back to double quotes
      def quote(value)
        return value.inspect unless value.is_a? String

        if value.include?("'")
          value.inspect
        else
          "'#{value}'"
        end
      end

    end
  end
end
