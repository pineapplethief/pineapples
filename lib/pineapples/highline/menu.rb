require 'highline/menu'

class Highline
  class Menu
    attr_accessor :index_prefix

    alias_method :old_initialize, :initialize

    def initialize
      @index_prefix = '    '
      old_initialize
    end

    def to_ary
      say 'to_ary called!'
      case @index
      when :number
        @items.map { |c| "   #{@index_prefix}#{@items.index(c) + 1}#{@index_suffix}#{c.first}" }
      when :letter
        l_index = "`"
        @items.map { |c| "   #{@index_prefix}#{l_index.succ!}#{@index_suffix}#{c.first}" }
      when :none
        @items.map { |c| "   #{@index_prefix}#{c.first}" }
      else
        @items.map { |c| "   #{@index_prefix}#{index}#{@index_suffix}#{c.first}" }
      end
    end
  end
end

