require 'pineapples/actions'
require 'pineapples/helpers'

module Pineapples
  class AppGenerator
    include Pineapples::Helpers

    attr_accessor :source_root, :templates_root, :target_dir
    attr_reader :app_name

    def initialize(argv)
      parse_cli_arguments(argv)
    end

    def start!
      # do stuff
    end

    def templates_root
      @templates_root ||= File.join(__dir__, 'templates')
    end

    def source_paths
      @source_paths ||= []
    end

    protected

    def templates_paths_for_search
      paths = []
      paths += templates_root
      paths << templates_root if templates_root
      paths
    end

    def parse_cli_arguments(argv)

    end

    # def settings
    #   @settings ||= Pineapples::Settings.new
    # end

    # def check_target
    #   unless Dir["#{@target_dir}/*"].empty?
    #     puts "Misfire! The target directory isn't empty... aim elsewhere."
    #     exit 1
    #   end
    # end

  end
end
