module Pineapples
  module Actions
    # Removes a file at the given location.
    #
    # ==== Parameters
    # path<String>:: path of the file to be changed
    # options<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Example
    #
    #   remove_file 'README'
    #   remove_file 'app/controllers/application_controller.rb'
    #
    def remove_file(path, options = {})
      return unless behaviour == :invoke
      path  = File.expand_path(path, app_root)

      message = relative_to_app_root(path)
      verbose = options.fetch(:verbose, verbose?)
      color = options.fetch(:color, :light_red)
      execute = options[:pretend] || execute?

      say_status :remove, message, color, verbose
      ::FileUtils.rm_rf(path) if execute && File.exist?(path)
    end
    alias_method :remove_dir, :remove_file
  end
end
