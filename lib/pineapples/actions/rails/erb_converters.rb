module Pineapples
  module Actions
    module Rails
      def erb2haml(target, options = {})
        recursive = options.fetch(:recursive, true)
        verbose = options.fetch(:verbose, verbose?)
        execute = !options.fetch(:pretend, pretend?)

        description = 'Convert ERB views to HAML'
        say_action(:erb2haml, description, verbose)

        if execute
          target_path = File.expand_path(target, app_root)
          target_path = File.join(target_path, recursive_mask) if recursive
          shell "find #{target_path} -name \\*.erb -print | sed 'p;s/.erb$/.haml/' | xargs -n2 html2haml",
                 verbose: false
        end
      end

      def erb2slim(target, options = {})
        recursive = options.fetch(:recursive, true)
        verbose = options.fetch(:verbose, verbose?)
        execute = !options.fetch(:pretend, pretend?)

        description = 'Convert ERB views to SLIM'
        say_action(:erb2slim, description, verbose)

        if execute
          erb2haml(target, options)
          target_path = File.expand_path(target, app_root)
          target_path = File.join(target_path, '**') if recursive
          shell "haml2slim #{target_path} --delete --trace", verbose: false
        end
      end
    end
  end
end
