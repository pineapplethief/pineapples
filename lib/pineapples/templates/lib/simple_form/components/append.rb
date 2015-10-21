module SimpleForm
  module Components
    module Append
      def append(wrapper_options = nil)
        @append ||= options[:append].to_s.html_safe if options[:append].present?
      end

      def has_append?
        append.present?
      end
    end
  end
end

SimpleForm::Inputs::Base.send(:include, SimpleForm::Components::Append)
