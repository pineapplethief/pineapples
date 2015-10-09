module Pineapples
  module Actions
    # Copies the file from the relative source to the relative destination. If
    # the destination is not given it's assumed to be equal to the source.
    #
    # ==== Parameters
    # source<String>:: the relative path to the source root.
    # target<String>:: the relative path to the destination root.
    # options<Hash>:: give :verbose => false to not log the status, and
    #                :mode => :preserve, to preserve the file mode from the source.

    #
    # ==== Examples
    #
    #   copy_file "README", "doc/README"
    #
    #   copy_file "doc/README"
    #
    def copy_file(source, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      target = args.first || source
      source = File.expand_path(find_in_source_paths(source.to_s))

      create_file(target, nil, options) do
        content = File.binread(source)
        content = block.call(content) if block
        content
      end
      if options[:mode] == :preserve
        mode = File.stat(source).mode
        chmod(target, mode, options)
      end
    end
  end
end
