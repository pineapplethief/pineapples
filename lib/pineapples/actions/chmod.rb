module Pineapples
  module Actions
    # Changes the mode of the given file or directory.
    #
    # ==== Parameters
    # mode<Integer>:: the file mode
    # path<String>:: the name of the file to change mode
    # options<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Example
    #
    #   chmod "script/server", 0755
    #
    def chmod(path, mode, options = {})
      return unless behaviour == :invoke

      verbose = options.fetch(:verbose, verbose?)
      execute = !options.fetch(:pretend, pretend?)
      color   = options.fetch(:color, DEFAULT_COLOR)

      relative_path = relative_to_app_root(File.join(app_root, path))

      say_status(:chmod, relative_path, color, verbose)

      FileUtils.chmod_R(mode, path) if execute
    end
  end
end
