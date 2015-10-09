require_relative 'empty_directory'
module Pineapples
  module Actions
    # Create a new file relative to the destination root with the given data,
    # which is the return value of a block or a data string.
    #
    # ==== Parameters
    # target<String>:: the relative path to the destination root.
    # content<String|NilClass>:: the data to append to the file.
    # options<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Examples
    #
    #   create_file "lib/fun_party.rb" do
    #     hostname = ask("What is the virtual hostname I should use?")
    #     "vhost.name = #{hostname}"
    #   end
    #
    #   create_file "config/apache.conf", "your apache config"
    #
    def create_file(target, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      content = args.first
      action CreateFile.new(self, target, block || content, options)
    end

    def ask_file_collision(target) # rubocop:disable MethodLength
      return true if @always_force
      options = '[Ynaq]'

      question_string = "Overwrite #{target}?"
      options = ['Yes', 'No', 'Always', 'Quit']

      loop do
        answer_index = Ask.list(question_string, options_with_color, inquirer_options)
        answer = options[answer_index]

        case answer
        when 'Yes'
          return true
        when 'No'
          return false
        when 'Always'
          return @always_force = true
        when 'Quit'
          say 'Aborting'
          raise SystemExit
        end
      end
    end

    class CreateFile < EmptyDirectory
      attr_reader :content

      status_color :identical, :neutral
      status_color :force, :warning
      status_color :skip, :warning
      status_color :conflict, :destructive

      def initialize(generator, target, content, options = {})
        super(generator, target, options)
        @content = content
      end

      def identical?
        exists? && File.binread(target) == render
      end

      def render
        @render ||= content.is_a?(Proc) ? content.call : content.to_s
      end

      def invoke!
        invoke_with_conflict_check do
          FileUtils.mkdir_p(File.dirname(target))
          File.open(target, 'wb') { |file| file.write render }
        end
        given_target
      end



      protected

      def on_conflict_behaviour(&block)
        if identical?
          say_status :identical
        else
          force_or_skip_on_conflict(options[:force], options[:skip], &block)
        end
      end

      def force_or_skip_or_conflict(force, skip, &block)
        if force
          say_status :force
          block.call if execute?
        elsif skip
          say_status :skip
        else
          say_status :conflict
          force_or_skip_or_conflict(force_on_collision?, true, &block)
        end
      end

      # Shows the file collision menu to the user and gets the result.
      #
      def force_on_collision?
        generator.ask_file_collision(target)
      end

    end
  end
end
