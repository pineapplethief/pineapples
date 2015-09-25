# require 'pineapples/actions/directory'

module Pineapples
  module Actions
    def shell(command)
      %x{#{command}}
      raise "#{command} failed with status #{$?.exitstatus}." unless $?.success?
    end

    def replace_in_file(relative_path, find, replace)
      path = File.join(destination_root, relative_path)
      contents = IO.read(path)
      unless contents.gsub!(find, replace)
        raise "#{find.inspect} not found in #{relative_path}"
      end
      File.open(path, 'w') { |file| file.write(contents) }
    end

  end
end
