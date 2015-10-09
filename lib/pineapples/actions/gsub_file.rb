module Pineapples
  module Actions
    # Run a regular expression replacement on a file.
    #
    # ==== Parameters
    # path<String>:: path of the file to be changed
    # flag<Regexp|String>:: the regexp or string to be replaced
    # replacement<String>:: the replacement, can be also given as a block
    # config<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Example
    #
    #   gsub_file 'app/controllers/application_controller.rb', /#\s*(filter_parameter_logging :password)/, '\1'
    #
    #   gsub_file 'README', /rake/, :green do |match|
    #     match << " no more. Use thor!"
    #   end
    #
    def gsub_file(path, flag, *args, &block)
      return unless behaviour == :invoke
      options = args.last.is_a?(Hash) ? args.pop : {}

      verbose = options.fetch(:verbose, verbose?)
      execute = options.fetch(:pretend, execute?)

      path = File.expand_path(path, app_root)
      say_status :gsub, relative_to_app_root(path), :light_yellow, verbose

      if execute
        content = File.binread(path)
        content.gsub!(flag, *args, &block)
        File.open(path, 'wb') { |file| file.write(content) }
      end
    end
  end
end
