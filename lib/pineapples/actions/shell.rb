module Pineapples
  module Actions
    # Executes a command returning the contents of the command.
    #
    # ==== Parameters
    # command<String>:: the command to be executed.
    # config<Hash>:: give :verbose => false to not log the status, :capture => true to hide to output. Specify :with
    #                to append an executable to command execution.
    #
    # ==== Example
    #
    #   inside 'vendor' do
    #     shell 'ln -s ~/edge rails'
    #   end
    #
    def shell(command, config = {})
      return if behavior == :revoke

      verbose = config.fetch(:verbose, verbose?)
      execute = !config.fetch(:pretend, pretend?)

      description = "#{command} from #{current_app_dir.inspect}"
      if config[:with]
        description = "#{File.basename(config[:with].to_s)} #{desc}"
        command = "#{config[:with]} #{command}"
      end

      say_action(:shell, description, verbose)

      if execute
        config[:capture] ? `#{command}` : system("#{command}")
      end

      raise Error, "#{command} failed with status #{$CHILD_STATUS.exitstatus}." if not $CHILD_STATUS.success?
    end
  end
end
