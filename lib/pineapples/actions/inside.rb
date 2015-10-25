module Pineapples
  module Actions
    def dir_stack
      @dir_stack ||= []
    end

    def current_app_dir
      File.expand_path(File.join(*dir_stack), app_root)
    end

    # Do something in the root or on a provided subfolder. The full path to
    # the directory is yielded to the block you provide.
    # The path is set back to the previous path when the method exits.
    #
    # ==== Parameters
    # dir<String>:: the directory to move to, relative to the app root
    # config<Hash>:: give :verbose => true to log and use padding.
    #
    def inside(dir = :root, options = {}, &block)
      verbose = options.fetch(:verbose, verbose?)
      color = options.fetch(:color, :light_green)

      status_dir = if dir == :root
                     relative_to_app_root(app_root)
                   else
                     relative_to_app_root(File.join(current_app_dir, dir))
                   end

      say_status(:inside, status_dir, color, verbose)

      indent(verbose) do
        with_directory(dir) do |target_dir|
          if !File.exist?(target_dir) && !pretend?
            FileUtils.mkdir_p(target_dir)
          end

          if pretend?
            block.arity == 1 ? yield(target_dir) : yield
          else
            FileUtils.cd(target_dir) do
              block.arity == 1 ? yield(target_dir) : yield
            end
          end
        end
      end
    end

    # Convenience method to call inside in_root
    def in_root(options = {})
      inside(:root, options) { yield }
    end

    def in_app_root(&block)
      Dir.chdir(app_root, &block)
    end

    private

    # helper method to abstract directory stack management in the #inside action
    def with_directory(dir)
      not_in_root = (dir != :root)

      dir_stack.push(dir) if not_in_root

      target_dir = not_in_root ? current_app_dir : app_root

      yield target_dir

      dir_stack.pop if not_in_root
    end

  end
end
