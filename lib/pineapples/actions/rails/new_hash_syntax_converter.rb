module Pineapples
  module Actions
    FILE_WITH_RUBY_CODE = '.rb|.erb|.haml|.slim|.rake'
    def convert_directory_to_new_hash_syntax(target, options = {})
      recursive = options.delete(:recursive, true)

      target_fullpath = File.expand_path(target, app_root)
      target_fullpath = File.join(target_fullpath, '**') if recursive

      excluded_files = Array(options[:exclude])
      exclude_pattern = options[:exclude_pattern]

      files = Dir.glob(target_fullpath, File::FNM_DOTMATCH)
      files.sort.each do |file|
        next if File.directory?(file)
        next if exclude_pattern && file.match(exclude_pattern)
        next if excluded_files.any? do |excluded_file|
          File.basename(excluded_file) == File.basename(file_source)
        end

        case file
        when /#{FILE_WITH_RUBY_CODE}$/
          convert_file_to_new_hash_syntax(file)
        end
      end

    end
    # Converts file to new Ruby hash syntax, cause that is what I prefer
    # Existing solutions on web usually use perl and shell, but we have
    # power of Ruby and cool gsub_file action at our disposal!
    def convert_file_to_new_hash_syntax(path)
      regex = /:(\w+)(\s{1})(\s*)=>/
      gsub_file(path, regex, '\1:\3')
    end
  end
end
