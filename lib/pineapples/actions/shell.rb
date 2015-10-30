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

    def shell_with_app_gemset(command, options = {})
      # we have to use PTY pseudo terminal to able to read shell subprocess output asynchronously.
      # Backticks and Kernel#system buffer output, and since bundle install takes forever to complete
      # it's not very user-friendly and program would seem to hang.
      # We just cd into project directory and invoke RVM in binary mode ('do' command)

      # TODO: add support for rbenv gemsets
      return if behaviour == :revoke
      verbose = options.fetch(:verbose, verbose?)
      execute = !options.fetch(:pretend, pretend?)

      full_command = "cd #{File.basename(app_root)}; rvm . do #{command}"
      say_status :shell, full_command, DEFAULT_COLOR, verbose

      if execute
        begin
          PTY.spawn(full_command) do |reader, writer, pid|
            loop do
              line = reader.gets
              break if !line
              puts line
            end
            Process.wait(pid)
          end
        rescue Errno::EIO => error
          nil
        rescue PTY::ChildExited => error
          puts 'The child process exited!'
        end
      end
    end

  end
end
