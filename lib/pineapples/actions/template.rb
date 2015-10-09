require 'erb'

module Pineapples
  module Actions
    # Gets an ERB template at the relative source, executes it and makes a copy
    # at the relative destination. If the destination is not given it's assumed
    # to be equal to the source removing .tt from the filename.
    #
    # ==== Parameters
    # source<String>:: the relative path to the source root.
    # target<String>:: the relative path to the destination root.
    # options<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Examples
    #
    #   template "README", "doc/README"
    #
    #   template "doc/README"
    #
    def template(source, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      target = args.first || source.sub(/#{TEMPLATE_EXTNAME}$/, '')

      source  = File.expand_path(find_in_source_paths(source.to_s))
      context = options.delete(:context) || instance_eval('binding')

      create_file(target, nil, options) do
        content = ERB.new(::File.binread(source), nil, '-', '@output_buffer').result(context)
        content = block.call(content) if block
        content
      end
    end
  end
end
