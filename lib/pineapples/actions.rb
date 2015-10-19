require 'fileutils'
require 'pathname'
require 'uri'
require 'pineapples/actions/base/action'
require 'pineapples/actions/base/target'
require 'pineapples/actions/apply'
require 'pineapples/actions/chmod'
require 'pineapples/actions/copy_file'
require 'pineapples/actions/create_file'
require 'pineapples/actions/directory'
require 'pineapples/actions/empty_directory'
require 'pineapples/actions/get'
require 'pineapples/actions/git'
require 'pineapples/actions/gsub_file'
require 'pineapples/actions/insert_into_file'
require 'pineapples/actions/inside'
require 'pineapples/actions/keep_file'
require 'pineapples/actions/prepend_to_class'
require 'pineapples/actions/remove_file'
require 'pineapples/actions/ruby'
require 'pineapples/actions/shell'
require 'pineapples/actions/template'

require 'pineapples/actions/rails/rails'

module Pineapples
  module Actions
    TEMPLATE_EXTNAME = '.tt'

    DEFAULT_COLOR = :light_green

    attr_reader :behaviour

    def initialize(options)
      super

      @behaviour = options.behaviour || :invoke
    end

    # Executes instance of Action subclass depending on generator behaviour
    def action(instance) #:nodoc:
      return if instance.skip?
      if behaviour == :invoke
        instance.invoke!
      else
        instance.revoke!
      end
    end

    def templates_root
      @templates_root ||= File.join(__dir__, 'templates')
    end

    def source_paths
      @source_paths ||= []
    end

    def source_paths_for_search
      paths = []
      paths += source_paths
      paths << templates_root if templates_root
      paths
    end

    # dir argument must me absolute path
    def relative_to_app_root(dir)
      @app_root_pathname ||= Pathname.new(app_root)
      path = Pathname.new(dir)
      path.relative_path_from(@app_root_pathname).to_s
    end

    def relative_to_current_app_dir(dir)
      current_app_path = Pathname.new(current_app_dir)
      path = Pathname.new(dir)
      path.relative_path_from(current_app_path).to_s
    end

    def find_in_source_paths(file)
      files_to_search = [file, file + TEMPLATE_EXTNAME]
      sources = source_paths_for_search

      sources.each do |source_path|
        files_to_search.each do |file|
          source_file = File.expand_path(file, source_path)
          return source_file if File.exist?(source_file)
        end
      end

      message = "Could not find #{file.inspect} in any of your source paths. "

      unless self.templates_root
        message << "Please set your generator instance template_root to PATH with the PATH containing your templates."
      end

      if sources.empty?
        message << "Currently you have no source paths."
      else
        message << "Your current source paths are: \n#{sources.join("\n")}"
      end

      raise Error, message
    end

    def say_status(status, message, color = :light_green, log = true)
      return if !log

      spaces = ' ' * $terminal.indent_size * 2

      status = status.to_s.rjust(12)
      status = status.colorize(color)

      output = "#{status}#{spaces}#{message}"

      say(output)
    end

    def indent(verbose = true, level_increment = 1)
      $terminal.indent_level += level_increment if verbose
      yield
      $terminal.indent_level -= level_increment if verbose
    end

  end
end
