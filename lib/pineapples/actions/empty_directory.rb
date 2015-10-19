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
      attr_reader :target,
                  :skip

      status_color :create, :creative
      status_color :remove, :destructive
      status_color :exist,  :neutral

      def initialize(generator, target, options = {})
        super(generator, options)

        @target = Target.new(target, self)
        @skip = @target.skip?
      end

      def invoke!
        invoke_with_conflict_check do
          ::FileUtils.mkdir_p(target.fullpath)
        end
      end

      def revoke!
        say_status :remove
        ::FileUtils.rm_rf(target.fullpath) if execute? && exists?
        given_target
      end

      def exists?
        ::File.exist?(target.fullpath)
      end

      protected

      def invoke_with_conflict_check(&block)
        if exists?
          on_conflict_behaviour(&block)
        else
          say_status :create
          block.call if execute?
        end

        target.fullpath
      end

      def on_conflict_behaviour(&block)
        say_status :exist
      end

      def message
        target.relative
      end

    end
  end
end
