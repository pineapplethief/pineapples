require_relative 'create_file'

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

      action CopyFile.new(self, source, target, options, &block)
    end

    class CopyFile < CreateFile
      attr_reader :source

      def initialize(generator, source, target, options, &block)
        @source  = File.expand_path(generator.find_in_source_paths(source.to_s))
        @content = File.binread(@source)
        @content = block.call(@content) if block
        super(generator, target, @content, options)
      end

      def invoke!
        super
        if options[:mode] == :preserve
          mode = File.stat(source).mode
          generator.chmod(target, mode, options)
        end
      end

    end
  end
end
