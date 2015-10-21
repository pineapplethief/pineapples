# monkey patch to generate attribute? predicate methods for Virtus attributes, a-la Rails
module Virtus
  class Attribute
    def define_accessor_methods(attribute_set)
      attribute_set.define_reader_method(self, name, options[:reader])
      attribute_set.define_writer_method(self, "#{name}=", options[:writer])
      attribute_set.define_presence_method(self, "#{name}?", options[:reader])
    end

    module Accessor
      def presence(instance)
        instance.instance_variable_get(instance_variable_name).present?
      end
    end
  end

  class AttributeSet
    def define_presence_method(attribute, method_name, visibility)
      define_method(method_name) { attribute.presence(self) }
      send(visibility, method_name)
    end
  end
end
