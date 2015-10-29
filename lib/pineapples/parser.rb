module Pineapples
  class Parser
    def self.parse(args)
      options = OpenStruct.new
      options.app_name = nil
      options.testing = false

      parser = OptionParser.new do |opts|
        opts.banner = 'Usage: pineapples [options] NEW_APP_DIRECTORY'

        opts.on('-t', '--testing', 'Runs pineapples in testing mode, without git setup') do
          options.testing = true
        end

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
        options.app_name = ARGV.first

        raise OptionParser::InvalidOption if options.app_name.nil?

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
