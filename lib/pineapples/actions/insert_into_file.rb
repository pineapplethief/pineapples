module Pineapples
  module Actions
    def insert_into_file(target, *args, &block)
      content = block_given? ? block : args.shift
      options = args.shift
      action InsertIntoFile.new(self, target, content, options)
    end

    # Append text to a file. Since it depends on insert_into_file, it's reversible.
    #
    # ==== Parameters
    # path<String>:: path of the file to be changed
    # data<String>:: the data to append to the file, can be also given as a block.
    # config<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Example
    #
    #   append_to_file 'config/environments/test.rb', 'config.gem "rspec"'
    #
    #   append_to_file 'config/environments/test.rb' do
    #     'config.gem "rspec"'
    #   end
    #
    def append_to_file(path, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(before: /\z/)
      insert_into_file(path, *(args << options), &block)
    end
    alias_method :append_file, :append_to_file

    # Prepend text to a file. Since it depends on insert_into_file, it's reversible.
    #
    # ==== Parameters
    # path<String>:: path of the file to be changed
    # content<String>:: the content to prepend to the file, can be also given as a block.
    # options<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Example
    #
    #   prepend_to_file 'config/environments/test.rb', 'config.gem "rspec"'
    #
    #   prepend_to_file 'config/environments/test.rb' do
    #     'config.gem "rspec"'
    #   end
    #
    def prepend_to_file(path, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      options.merge!(after: /\A/)
      insert_into_file(path, *(args << options), &block)
    end
    alias_method :prepend_file, :prepend_to_file

    class InsertIntoFile < EmptyDirectory
      attr_reader :new_content,
                  :flag,
                  :behaviour

      status_color :prepend,   :creative
      status_color :append,    :creative
      status_color :insert,    :creative
      status_color :substract, :destructive

      def initialize(generator, target, new_content, options)
        super(generator, target, {verbose: true}.merge(options))

        @behaviour = @config.key?(:after) ? :after : :before
        @flag = @options.delete(@behaviour)

        @new_content = new_content.is_a?(Proc) ? new_content.call : new_content
        @flag = Regexp.escape(@flag) if !@flag.is_a?(Regexp)
      end

      def invoke!
        say_status status(:invoke)

        content = if @behavior == :after
                    '\0' + replacement
                  else
                    replacement + '\0'
                  end

        regexp = /#{flag}/

        replace!(regexp, content, options[:force])
      end

      def revoke!
        say_status status(:revoke)

        if @behavior == :after
          content = '\1\2'
          regexp = /(#{flag})(.*)(#{Regexp.escape(new_content)})/m
        else
          content = '\2\3'
          regexp = /(#{Regexp.escape(new_content)})(.*)(#{flag})/m
        end

        replace!(regexp, content, true)
      end



      protected

      def status(execution_style)
        if execution_style == :invoke
          if flag == /\A/
            :prepend
          elsif flag == /\z/
            :append
          else
            :insert
          end
        else
          :subtract
        end
      end

      def replace!(regexp, string, force)
        if execute?
          content = File.binread(target)
          if force || !content.include?(new_content)
            content.gsub!(regexp, string)
            File.open(target, 'wb') { |file| file.write(content) }
          end
        end
      end

    end
  end
end
