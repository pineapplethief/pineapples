class String
  def to_bool
    return true if self == true || self =~ (/^(true|t|yes|y|1)$/i)
    return false if self.blank? || self =~ (/^(false|f|no|n|0)$/i)
  end
end

class Symbol
  def to_bool
    truthy = [:true, :t, :yes, :y]
    truthy.include?(self)
  end
end

class Numeric
  def to_bool
    self.nonzero?
  end
end

class TrueClass
  def to_i
    1
  end

  def to_bool
    self
  end
end

class FalseClass
  def to_i
    0
  end

  def to_bool
    self
  end
end

class NilClass
  def to_bool
    false
  end
end
