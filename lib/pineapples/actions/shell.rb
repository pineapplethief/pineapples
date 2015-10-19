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
      return if behavior == :revoke

      verbose = options.fetch(:verbose, verbose?)
      execute = !options.fetch(:pretend, pretend?)

      description = "#{command} from #{current_app_dir.inspect}"

      executable = options[:with].to_s

      if executable.present?
        description = "#{File.basename(executable)} #{desc}"
        command = "#{executable} #{command}"
      end

      say_action(:shell, description, verbose)

      if execute
        config[:capture] ? `#{command}` : system("#{command}")
        raise Error, "#{command} failed with status #{$CHILD_STATUS.exitstatus}." if not $CHILD_STATUS.success?
      end
    end

  end
end
