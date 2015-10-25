require ''
module Pineapples
  module Helpers
    RESERVED_NAMES = %w[application destroy plugin runner test]

    def needs_user_model?
      user_role_field? || devise?
    end

    protected

    def humanized_application_name
      app_name.underscore.humanize.gsub(/\S+/, &:capitalize)
    end

    def app_const_base
      @app_const_base ||= app_name.gsub(/\W/, '_').squeeze('_').camelize
    end

    def app_const
      @app_const ||= "#{app_const_base}::Application"
    end

    def valid_const!
      if app_const =~ /^\d/
        raise Error, "Invalid application name #{app_name}. Please give a name which does not start with numbers."
      elsif RESERVED_NAMES.include?(app_name)
        raise Error, "Invalid application name #{app_name}. Please give a name which does not match one of the reserved rails words."
      elsif Object.const_defined?(app_const_base)
        raise Error, "Invalid application name #{app_name}, constant #{app_const_base} is already in use. Please choose another application name."
      end
    end

    def app_secret
      SecureRandom.hex(64)
    end

    def preexisting_git_repo?
      if @preexisting_git_repo.nil?
        git_path = File.expand_path('.git', app_root)
        @preexisting_git_repo = File.exist?(git_path)
      end
      @preexisting_git_repo
    end

    def rbenv_installed?
      @rbenv_installed = `which rbenv`.length > 0 if @rbenv_installed.nil?
      @rbenv_installed
    end

    def rvm_installed?
      @rvm_installed = `rvm -v`.length > 0 if @rvm_installed.nil?
      @rvm_installed
    end

  end
end
