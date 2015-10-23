module Pineapples
  module Actions
    def bundle(command, subcommands = nil)
      command = "#{command.key} #{command.value}" if command.is_a?(Hash)
      say_status :run, "bundle #{command} #{subcommands}"

      _bundle_command = Gem.bin_path('bundler', 'bundle')

      require 'bundler'
      Bundler.with_clean_env do
        output = `"#{Gem.ruby}" "#{_bundle_command}" #{command} #{subcommands}`
        print output unless options[:quiet]
      end
    end
  end
end
