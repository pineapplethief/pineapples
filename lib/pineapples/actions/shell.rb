module Pineapples
  module Actions
    # Executes a command returning the contents of the command.
    #
    # ==== Parameters
    # command<String>:: the command to be executed.
    # options<Hash>:: give :verbose => false to not log the status, :capture => true to hide to output. Specify :with
    #                to append an executable to command execution.
    #
    # ==== Example
    #
    #   inside 'vendor' do
    #     shell 'ln -s ~/edge rails'
    #   end
    #
    def shell(command, options = {})
      return if behaviour == :revoke

      verbose = options.fetch(:verbose, verbose?)
      execute = !options.fetch(:pretend, pretend?)

      executable = options[:with].to_s

      command = "#{executable} #{command}" if executable.present?

      say_status(:shell, command, DEFAULT_COLOR, verbose)

      if execute
        options[:capture] ? `#{command}` : system("#{command}")
        raise Error, "#{command} failed with status #{$CHILD_STATUS.exitstatus}." if not $CHILD_STATUS.success?
      end
    end

    def shell_with_clean_bundler_env(command, options = {})
      return shell(command, options) if !defined?(Bundler)
      Bundler.with_clean_env do
        shell(command, options)
      end
    end

  end
end
