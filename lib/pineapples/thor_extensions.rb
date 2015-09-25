class Thor
  class Option
    def default_text
      if boolean?
        default ? 'yes' : 'no'
      elsif string?
        default
      end
    end

    def has_default?
      !default.nil? && !default.empty?
    end

  end
end
