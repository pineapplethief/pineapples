module Pineapples
  module Actions
    def bundle(command, subcommands = nil, options = {})
      command = "#{command.first.first} #{command.first.last}" if command.is_a?(Hash)
      say_status :shell, "bundle #{command} #{subcommands}"

      _bundle_command = Gem.bin_path('bundler', 'bundle')

      require 'bundler'
      Bundler.with_clean_env do
        output = `"#{Gem.ruby}" "#{_bundle_command}" #{command} #{subcommands}`
        print output if !options[:quiet]
      end
    end
  end
end
