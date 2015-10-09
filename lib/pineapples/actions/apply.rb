module Pineapples
  module Actions
    # Loads an external file and execute it in the instance binding.
    #
    # ==== Parameters
    # path<String>:: The path to the file to execute. Can be a web address or
    #                a relative path from the source root.
    #
    # ==== Examples
    #
    #   apply "http://gist.github.com/103208"
    #
    #   apply "recipes/jquery.rb"
    #
    def apply(path, options = {})
      verbose = options.fetch(:verbose, verbose?)
      is_uri  = path =~ %r{^https?\://}
      path    = find_in_source_paths(path) if !is_uri
      color   = options.fetch(:color, DEFAULT_COLOR)

      say_status(:apply, path, color, verbose)

      indent(verbose) do
        if is_uri
          contents = open(path, 'Accept' => 'application/x-thor-template') { |io| io.read }
        else
          contents = open(path) { |io| io.read }
        end

        instance_eval(contents, path)
      end
    end
  end
end
