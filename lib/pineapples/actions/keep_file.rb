require_relative 'empty_directory'

module Pineapples
  module Actions
    def empty_directory_with_keep_file(target, options = {})
      empty_directory(target, options)
      keep_file(destination)
    end

    def keep_file(target)
      create_file("#{target}/.keep")
    end

  end
end
