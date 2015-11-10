module Pineapples
  module Actions
    module Rails
      def erb2haml(target, options = {})
        recursive = options.fetch(:recursive, true)
        verbose = options.fetch(:verbose, verbose?)
        execute = !options.fetch(:pretend, pretend?)
        preserve = options.fetch(:keep_old_files, false)

        description = 'Convert ERB views to HAML'
        say_status(:erb2haml, description, verbose)

        if execute
          target_path = File.expand_path(target, app_root)
          target_path = File.join(target_path, '**') if recursive
          shell "find #{target_path} -name \\*.erb -print | sed 'p;s/.erb$/.haml/' | xargs -n2 html2haml",
                 verbose: false
          if !preserve
            erb_pattern = File.join(target_path, '*.erb')
            Dir.glob(erb_pattern).each { |file| ::FileUtils.rm_f(file) }
          end
        end
      end

      def erb2slim(target, options = {})
        recursive = options.fetch(:recursive, true)
        verbose = options.fetch(:verbose, verbose?)
        execute = !options.fetch(:pretend, pretend?)
        preserve = options.falsetch(:keep_old_files, false)

        description = 'Convert ERB views to SLIM'
        say_status(:erb2slim, description, verbose)

        if execute
          erb2haml(target, options)
          target_path = File.expand_path(target, app_root)
          target_path = File.join(target_path, '**') if recursive
          shell "haml2slim #{target_path} #{preserve ? '' : '--delete'} --trace", verbose: false
        end
      end

    end
  end
end
