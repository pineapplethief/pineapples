require 'find'
require 'pineapples/actions/action'
require 'pineapples/actions/shell'

module Pineapples
  module Actions
    TEMPLATE_EXTNAME = '.tt'

    attr_reader :behaviour

    def initialize(options)
      super
      @behaviour = options.behaviour || :invoke
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

    def relative_to_original_destination_root(path, remove_dot = true)
      path = path.dup
      if path.gsub!(source_paths.first, '.')
        remove_dot ? (path[2..-1] || "") : path
      else
        path
      end
    end

    def find_in_source_paths(file)
      files_to_search = [file, file + TEMPLATE_EXTNAME]
      relative_root = relative_to_original_destination_root(app_root, false)

      source_paths.each do |source_path|
        files_to_search.each do |file|
          source_file = File.expand_path(file, File.join(source_path, relative_root))
          return source_file if File.exist?(source_file)
        end
      end

      message = "Could not find #{file.inspect} in any of your source paths. "

      unless self.templates_root
        message << "Please set your generator instance template_root to PATH with the PATH containing your templates."
      end

      if source_paths.empty?
        message << "Currently you have no source paths."
      else
        message << "Your current source paths are: \n#{source_paths.join("\n")}"
      end

      raise Error, message
    end

    def say_action(action, message, log_status = true)
      return if !log_status
      spaces = $terminal.indentation

      action = action.to_s.rjust(12)

      if behaviour == :invoke
        action = action.green
      elsif behaviour = :revoke
        action = action.red
      end

      output = "#{action}#{spaces}#{message}"

      say output
    end

  end
end
