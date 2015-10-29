module Pineapples
  module Actions
    class Target
      PASS_REGEX      = /!=(.*?)!/
      GUARD_REGEX     = /!(.*?)!/
      FILENAME_REGEX  = /%(.*?)%/

      attr_reader :given,
                  :fullpath,
                  :relative,
                  :generator

      def initialize(target, generator)
        raise Error, 'Target should not be falsy' if !target

        @generator = generator
        @given = target.to_s

        match!

        @fullpath = File.expand_path(@given, generator.current_app_dir)
        @relative = generator.relative_to_current_app_dir(@fullpath)
      end

      def skip?
        @skip
      end

      private

      def match!
        loop do
          matched = false
          [:pass, :guard, :filename].each do |type|
            if match(type)
              send(:"evaluate_#{type}_method!")
              matched = true and break
            end
          end
          break if !matched || @skip
        end
      end

      def evaluate_pass_method!
        method = find_generator_method!(methods_to_find(:pass))
        @skip = !generator.send(method)
        @given.sub!(match(:pass)[0], '')
      end

      def evaluate_guard_method!
        method = find_generator_method!(methods_to_find(:guard))
        @skip = generator.send(method)
        @given.sub!(match(:guard)[0], '')
      end

      def evaluate_filename_method!
        method = find_generator_method!(methods_to_find(:filename))
        filename = generator.send(method)
        @given.sub!(match(:filename)[0], filename)
      end

      def match(type)
        regexp = self.class.const_get(type.to_s.upcase + '_REGEX')
        regexp.match(@given)
      end

      def methods_to_find(type)
        method = match(type)[1].strip
        type == :filename ? method : [method, method + '?']
      end

      def find_generator_method!(methods)
        Array(methods).each { |method| return method if generator.respond_to?(method, true) }
        raise Error, methods_missing_error_message(methods)
      end

      def methods_missing_error_message(methods)
        methods = Array(methods)
        methods_message = methods.length > 1 ? 'methods' : 'method'

        "No instance #{methods_message} #{methods.join(', ')} for AppGenerator, can't evaluate filepath #{given}"
      end
    end

  end
end
