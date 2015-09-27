require 'pineapples/actions'
require 'pineapples/helpers'
require 'pineapples/settings'

module Pineapples
  class AppGenerator
    extend Pineapples::Settings
    include Pineapples::Helpers
    include Pineapples::Actions

    TEMPLATING_ENGINES = [:erb, :haml, :slim]

    setting :template_engine, type: :symbol, default: :erb, options: TEMPLATING_ENGINES,
            prompt: 'Select templating engine used in the app'

    attr_accessor :source_paths, :templates_root, :target_dir, :settings

    def initialize(options)
      @target_dir = options.target_dir
      @settings = self.class.settings
    end

    def start!
      ask_user_settings
    end

    def ask_user_settings
      settings[:template_engine].ask
    end

    def templates_root
      @templates_root ||= File.join(__dir__, 'templates')
    end

    def source_paths
      @source_paths ||= []
    end

    protected

    def source_paths_for_search
      paths = []
      paths += source_paths
      paths << templates_root if templates_root
      paths
    end

    def app_name
      @app_name ||= File.basename(target_dir).gsub(/\s+/, '-')
    end

    # def check_target
    #   unless Dir["#{@target_dir}/*"].empty?
    #     puts "Misfire! The target directory isn't empty... aim elsewhere."
    #     exit 1
    #   end
    # end

  end
end
