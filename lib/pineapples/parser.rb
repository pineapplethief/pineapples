module Pineapples
  class Parser
    def self.parse(args)
      options = OpenStruct.new
      options.target_dir = nil

      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: pineapples [options] NEW_APP_DIRECTORY'

        opts.on('-h', '--help', 'Show pineapples usage') do
          self.usage_and_exit(opts)
        end

        opts.on_tail('-v', '--version', 'Show version') do
          puts Pineapples::VERSION
          exit 1
        end
      end

      begin
        parser.parse!
        options.target_dir = ARGV.first

        raise OptionParser::InvalidOption if options.target_dir.nil?

        options
      rescue OptionParser::InvalidOption
        self.usage_and_exit(parser)
      end
    end

    def self.usage_and_exit(parser)
      say parser
      exit 1
    end
  end
end
