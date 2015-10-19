require 'open-uri'

module Pineapples
  module Actions
    # Gets the content at the given address and places it at the given relative
    # destination. If a block is given instead of destination, the content of
    # the url is yielded and used as location.
    #
    # ==== Parameters
    # source<String>:: the address of the given content.
    # target<String>:: the relative path to the destination root.
    # options<Hash>:: give :verbose => false to not log the status.
    #
    # ==== Examples
    #
    #   get "http://gist.github.com/103208", "doc/README"
    #
    #   get "http://gist.github.com/103208" do |content|
    #     content.split("\n").first
    #   end
    #
    def get(source, *args, &block)
      options = args.last.is_a?(Hash) ? args.pop : {}
      target = args.first

      source = File.expand_path(find_in_source_paths(source.to_s)) unless source =~ %r{^https?\://}
      render = open(source) { |input| input.binmode.read }

      target ||= if block
                   block.arity == 1 ? block.call(render) : block.call
                 else
                   File.basename(source)
                 end

      create_file(target, render, options)
    end
  end
end
