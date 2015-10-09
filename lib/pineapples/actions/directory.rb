module Pineapples
  module Actions
    # Copies recursively the files from source directory to root directory.
    # If any of the files finishes with .tt, it's considered to be a template
    # and is placed in the destination without the extension .tt. If any
    # empty directory is found, it's copied and all .empty_directory files are
    # ignored. If any file name is wrapped within % signs, the text within
    # the % signs will be executed as a method and replaced with the returned
    # value. Let's suppose a doc directory with the following files:
    #
    #   doc/
    #     components/.empty_directory
    #     README
    #     rdoc.rb.tt
    #     %app_name%.rb
    #
    # When invoked as:
    #
    #   directory "doc"
    #
    # It will create a doc directory in the destination with the following
    # files (assuming that the `app_name` method returns the value "blog"):
    #
    #   doc/
    #     components/
    #     README
    #     rdoc.rb
    #     blog.rb
    #
    # ==== Parameters
    # source<String>:: the relative path to the source root.
    # target<String>:: the relative path to the destination root.
    # options<Hash>:: give :verbose => false to not log the status.
    #                If :recursive => false, does not look for paths recursively.
    #                If :mode => :preserve, preserve the file mode from the source.
    #                If :exclude_pattern => /regexp/, prevents copying files that match that regexp.
    #
    # ==== Examples
    #
    #   directory "doc"
    #   directory "doc", "docs", :recursive => false
    #
    def directory(source, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      target = args.first || source
      action Directory.new(self, source, target, options, &block)
    end

    class Directory < EmptyDirectory
      attr_reader :source

      def initialize(generator, source, target, options, &block)
        super(generator, target, {recursive: true}.merge(options))

        @source = File.expand_path(generator.find_in_source_paths(source.to_s))
        @block  = block
      end

      def invoke!
        generator.empty_directory(given_target, options)
        execute!
      end

      def revoke!
        execute!
      end

      protected

      def execute!
        lookup = escape_globs(source)
        lookup = options[:recursive] ? File.join(lookup, '**') : lookup
        lookup = file_level_lookup(lookup)

        excluded_files = Array(options[:exclude])

        files(lookup).sort.each do |file_source|
          next if File.directory?(file_source)
          next if options[:exclude_pattern] && file_source.match(options[:exclude_pattern])
          next if excluded_files.any? do |excluded_file|
            File.basename(excluded_file) == File.basename(file_source)
          end

          file_target = File.join(given_target, file_source.gsub(source, '.'))
          file_target.gsub!('/./', '/')

          case file_source
          when /\.empty_directory$/
            dirname = File.dirname(file_target).gsub(/\/\.$/, '')
            next if dirname == given_target
            generator.empty_directory(dirname, options)
          when /#{TEMPLATE_EXTNAME}$/
            generator.template(file_source, file_target[0..-4], options, &@block)
          else
            generator.copy_file(file_source, file_target, options, &@block)
          end
        end
      end

      def file_level_lookup(previous_lookup)
        File.join(previous_lookup, '*')
      end

      def files(lookup)
        Dir.glob(lookup, File::FNM_DOTMATCH)
      end

      def escape_globs(path)
        path.to_s.gsub(/[*?{}\[\]]/, '\\\\\\&')
      end
    end

  end
end
