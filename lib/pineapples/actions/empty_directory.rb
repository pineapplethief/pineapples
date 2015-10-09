module Pineapples
  module Actions
    # Creates an empty directory.
    #
    # ==== Parameters
    # target<String>:: the relative path to the app root.
    # options<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Examples
    #
    #   empty_directory "doc"
    #
    def empty_directory(target, options = {})
      action EmptyDirectory.new(self, target, options)
    end

    class EmptyDirectory < Action
      attr_reader :given_target,
                  :target,
                  :relative_target
                  :skip

      status_color :create, :creative
      status_color :remove, :destructive
      status_color :exist,  :neutral

      def initialize(generator, target, options = {})
        super(generator, options)
        @skip = false

        self.target = target
      end

      def invoke!
        invoke_with_conflict_check do
          ::FileUtils.mkdir_p(target)
        end
      end

      def revoke!
        say_status :remove
        ::FileUtils.rm_rf(target) if execute? && exists?
        given_target
      end

      def exists?
        ::File.exist?(target)
      end

      def skip?
        @skip
      end

      protected

      def target=(target)
        if target
          @given_target = evaluate_filename(target.to_s)
          @target = ::File.expand_path(@given_target, generator.current_app_dir)
          @relative_target = generator.relative_to_current_app_dir(@target)
        end
      end

      def evaluate_filename(filename)
        guard_match = /!(.*?)!/.match(filename)
        if guard_match
          guard_method = guard_match[1].strip
          if generator.respond_to?(guard_method, true)
            should_skip = generator.send(guard_method)
            @skip = true if should_skip
            filename.gsub!(guard_match[0])
          else
            raise Error, "No instance method #{guard_method} on generator instance, can't evaluate filename"
          end
        end

        match = /%(.*?)%/.match(filename)
        if match
          method = match[1].strip
          generator.respond_to?(method, true) ? generator.send(method) : filename
        else
          filename
        end
      end

      def invoke_with_conflict_check(&block)
        if exists?
          on_conflict_behaviour(&block)
        else
          say_status :create
          block.call if execute?
        end

        target
      end

      def on_conflict_behaviour(&block)
        say_status :exist
      end

      def message
        relative_target
      end

    end
  end
end
