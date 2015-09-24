require 'thor/actions/directory'

class Thor
  module Actions
    def directory(source, *args, &block)
      config = args.last.is_a?(Hash) ? args.pop : {}
      destination = args.first || source
      action PineapplesDirectory.new(self, source, destination || source, config, &block)
    end
  end

  class PineapplesDirectory < Thor::Actions::Directory
    def initialize(*args)
      super
    end

    def execute! # rubocop:disable MethodLength
      lookup = Util.escape_globs(source)
      lookup = config[:recursive] ? File.join(lookup, '**') : lookup
      lookup = file_level_lookup(lookup)

      excluded_files = Array(config[:exclude])

      files(lookup).sort.each do |file_source|
        next if File.directory?(file_source)
        next if config[:exclude_pattern] && file_source.match(config[:exclude_pattern])
        next if excluded_files.any? { |excluded| file_source.include?(excluded) }
        file_destination = File.join(given_destination, file_source.gsub(source, "."))
        file_destination.gsub!("/./", "/")

        case file_source
        when /\.empty_directory$/
          dirname = File.dirname(file_destination).gsub(/\/\.$/, "")
          next if dirname == given_destination
          base.empty_directory(dirname, config)
        when /#{TEMPLATE_EXTNAME}$/
          base.template(file_source, file_destination[0..-4], config, &@block)
        else
          base.copy_file(file_source, file_destination, config, &@block)
        end
      end
    end

  end
end
