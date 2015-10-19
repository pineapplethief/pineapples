require_relative 'shell'
module Pineapples
  module Actions
    # Executes a ruby script (taking into account WIN32 platform quirks).
    #
    # ==== Parameters
    # command<String>:: the command to be executed.
    # options<Hash>:: give :verbose => false to not log the status.
    #
    def ruby(command, options = {})
      return if behaviour != :inboke
      shell(command, options.merge(with: ruby_command))
    end

    private
    # Return the path to the ruby interpreter taking into account multiple
    # installations and windows extensions.
    #
    def ruby_command # rubocop:disable MethodLength
      @ruby_command ||= begin
        ruby_name = RbConfig::CONFIG['ruby_install_name']
        ruby = File.join(RbConfig::CONFIG['bindir'], ruby_name)
        ruby << RbConfig::CONFIG['EXEEXT']

        # avoid using different name than ruby (on platforms supporting links)
        if ruby_name != 'ruby' && File.respond_to?(:readlink)
          begin
            alternate_ruby = File.join(RbConfig::CONFIG['bindir'], 'ruby')
            alternate_ruby << RbConfig::CONFIG['EXEEXT']

            # ruby is a symlink
            if File.symlink? alternate_ruby
              linked_ruby = File.readlink alternate_ruby

              # symlink points to 'ruby_install_name'
              ruby = alternate_ruby if linked_ruby == ruby_name || linked_ruby == ruby
            end
          rescue NotImplementedError # rubocop:disable HandleExceptions
            # just ignore on windows
          end
        end

        # escape string in case path to ruby executable contain spaces.
        ruby.sub!(/.*\s.*/m, '"\&"')
        ruby
      end
    end
  end
end
