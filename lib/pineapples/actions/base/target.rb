module Pineapples
  module Actions
    class Target
      PASS_MATCH  = /!=(.*?)!/
      GUARD_MATCH = /!(.*?)!/
      EVAL_MATCH  = /%(.*?)%/

      attr_reader :given,
                  :fullpath,
                  :relative,
                  :action

      def initialize(target, action)
        raise Error, 'Target should not be falsy' if !target

        @action = action
        @given = target.to_s

        evaluate_pass_method!
        evaluate_guard_methods!
        evaluate_filename_method!

        @fullpath = File.expand_path(@given, generator.current_app_dir)
        @relative = generator.relative_to_current_app_dir(@fullpath)
      end

      def generator
        action.generator
      end

      def skip?
        @skip = false if @skip.nil?
        @skip
      end

      private

      def evaluate_pass_method!
        if pass_match
          raise Error, methods_missing_error_message(pass_methods) if !generator_pass_method

          @skip = !generator.send(generator_pass_method)
          @given.gsub!(pass_match[0], '')
        end
      end

      def evaluate_guard_methods!
        if guard_match
          raise Error, methods_missing_error_message(guard_methods) if !generator_guard_method

          @skip = generator.send(generator_guard_method)
          @given.gsub!(guard_match[0], '')
        end
      end

      def evaluate_filename_method!
        if eval_match
          raise Error, methods_missing_error_message(filename_method) if !generator_filename_method

          filename = generator.send(filename_method)
          @given.gsub!(eval_match[0], filename)
        end
      end

      def pass_match
        PASS_MATCH.match(@given)
      end

      def guard_match
        GUARD_MATCH.match(@given)
      end

      def eval_match
        EVAL_MATCH.match(@given)
      end

      def generator_pass_method
        if @pass_method.nil?
          pass_methods.each do |method|
            if generator.respond_to?(method, true)
              @pass_method = method
              break
            end
          end
        end
        @pass_method = false if @pass_method.nil?
        @pass_method
      end

      def generator_guard_method
        if @guard_method.nil?
          guard_methods.each do |method|
            if generator.respond_to?(method, true)
              @guard_method = method
              break
            end
          end
        end
        @guard_method = false if @guard_method.nil?
        @guard_method
      end

      def generator_filename_method
        if @filename_method.nil?
          @filename_method = generator.respond_to?(filename_method, true) ? filename_method : false
        end
        @filename_method
      end

      def guard_methods
        guard_method = guard_match[1].strip
        predicate_method = guard_method + '?'
        [guard_method, predicate_method]
      end

      def pass_methods
        pass_method = pass_match[1].strip
        predicate_method = pass_method + '?'
        [pass_method, predicate_method]
      end

      def filename_method
        eval_match[1].strip
      end

      def methods_missing_error_message(methods)
        plural = methods.is_a?(Array)
        methods = methods.join(', ') if plural
        methods_message = plural ? 'methods' : 'method'

        "No instance #{methods_message} #{methods} for AppGenerator, can't evaluate filepath #{given}"
      end
    end

  end
end
